package testimpl

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"os"
	"strconv"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	r53 "github.com/aws/aws-sdk-go-v2/service/route53"
	r53types "github.com/aws/aws-sdk-go-v2/service/route53/types"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func dnsNorm(s string) string {
	s = strings.TrimSpace(s)
	if s == "" {
		return s
	}
	if !strings.HasSuffix(s, ".") {
		s += "."
	}
	return strings.ToLower(s)
}

func awsRegion() string {
	for _, v := range []string{os.Getenv("AWS_DEFAULT_REGION"), os.Getenv("AWS_REGION")} {
		if v != "" {
			return v
		}
	}
	return "us-east-1"
}

func route53Client(t *testing.T) *r53.Client {
	t.Helper()
	cfg, err := config.LoadDefaultConfig(context.Background(), config.WithRegion(awsRegion()))
	require.NoError(t, err)
	return r53.NewFromConfig(cfg)
}

func findRecordSet(t *testing.T, ctx context.Context, client *r53.Client, zoneID, wantName, wantType string) *r53types.ResourceRecordSet {
	t.Helper()
	want := dnsNorm(wantName)
	paginator := r53.NewListResourceRecordSetsPaginator(client, &r53.ListResourceRecordSetsInput{
		HostedZoneId: aws.String(zoneID),
	})
	for paginator.HasMorePages() {
		out, err := paginator.NextPage(ctx)
		require.NoError(t, err)
		for i := range out.ResourceRecordSets {
			rs := &out.ResourceRecordSets[i]
			if string(rs.Type) != wantType {
				continue
			}
			if dnsNorm(aws.ToString(rs.Name)) == want {
				return rs
			}
		}
	}
	return nil
}

func verifyRoute53Record(t *testing.T, testCtx types.TestContext, client *r53.Client) {
	t.Helper()
	ctx := context.Background()
	opts := testCtx.TerratestTerraformOptions()
	zoneID := terraform.OutputContext(t, context.Background(), opts, "hosted_zone_id")
	typeOut := terraform.OutputContext(t, context.Background(), opts, "record_type")
	ttlStr := terraform.OutputContext(t, context.Background(), opts, "record_ttl")
	expectedRecords := terraform.OutputListContext(t, context.Background(), opts, "expected_records")
	fqdnOut := terraform.OutputContext(t, context.Background(), opts, "fqdn")

	ttlVal, err := strconv.ParseInt(ttlStr, 10, 64)
	require.NoError(t, err)

	rs := findRecordSet(t, ctx, client, zoneID, fqdnOut, typeOut)
	require.NotNil(t, rs, "record should exist in Route 53")
	require.NotNil(t, rs.TTL, "TTL should be present for this record")
	assert.Equal(t, ttlVal, *rs.TTL, "TTL should match configuration")

	var got []string
	for _, rr := range rs.ResourceRecords {
		got = append(got, aws.ToString(rr.Value))
	}
	assert.Equal(t, expectedRecords, got, "record values should match configuration")
	assert.Equal(t, dnsNorm(fqdnOut), dnsNorm(aws.ToString(rs.Name)), "FQDN should match API name")
}

func upsertAndDeleteTXTRecord(t *testing.T, testCtx types.TestContext, client *r53.Client) {
	t.Helper()
	ctx := context.Background()
	opts := testCtx.TerratestTerraformOptions()
	zoneID := terraform.OutputContext(t, context.Background(), opts, "hosted_zone_id")
	zoneName := strings.Trim(terraform.OutputContext(t, context.Background(), opts, "zone_name"), ".")

	var rnd [4]byte
	_, err := rand.Read(rnd[:])
	require.NoError(t, err)
	txtName := "_ttw" + hex.EncodeToString(rnd[:]) + "." + zoneName

	upsert := &r53.ChangeResourceRecordSetsInput{
		HostedZoneId: aws.String(zoneID),
		ChangeBatch: &r53types.ChangeBatch{
			Changes: []r53types.Change{
				{
					Action: r53types.ChangeActionUpsert,
					ResourceRecordSet: &r53types.ResourceRecordSet{
						Name: aws.String(txtName),
						Type: r53types.RRTypeTxt,
						TTL:  aws.Int64(60),
						ResourceRecords: []r53types.ResourceRecord{
							{Value: aws.String("\"terratest-write\"")},
						},
					},
				},
			},
		},
	}
	_, err = client.ChangeResourceRecordSets(ctx, upsert)
	require.NoError(t, err)

	t.Cleanup(func() {
		del := &r53.ChangeResourceRecordSetsInput{
			HostedZoneId: aws.String(zoneID),
			ChangeBatch: &r53types.ChangeBatch{
				Changes: []r53types.Change{
					{
						Action: r53types.ChangeActionDelete,
						ResourceRecordSet: &r53types.ResourceRecordSet{
							Name: aws.String(txtName),
							Type: r53types.RRTypeTxt,
							TTL:  aws.Int64(60),
							ResourceRecords: []r53types.ResourceRecord{
								{Value: aws.String("\"terratest-write\"")},
							},
						},
					},
				},
			},
		}
		_, delErr := client.ChangeResourceRecordSets(context.Background(), del)
		assert.NoError(t, delErr)
	})

	found := findRecordSet(t, ctx, client, zoneID, txtName, "TXT")
	require.NotNil(t, found, "TXT record written via API should be visible")
	require.Len(t, found.ResourceRecords, 1)
	assert.Equal(t, "\"terratest-write\"", aws.ToString(found.ResourceRecords[0].Value))
}

// TestComposableComplete deploys with Terratest, verifies the record via the Route 53 API, and performs a Route 53 write.
func TestComposableComplete(t *testing.T, testCtx types.TestContext) {
	client := route53Client(t)
	verifyRoute53Record(t, testCtx, client)
	t.Run("route53APIWrite", func(t *testing.T) {
		upsertAndDeleteTXTRecord(t, testCtx, client)
	})
}

// TestComposableCompleteReadOnly verifies Terraform outputs and Route 53 state using read-only API calls only.
func TestComposableCompleteReadOnly(t *testing.T, testCtx types.TestContext) {
	client := route53Client(t)
	verifyRoute53Record(t, testCtx, client)
}
