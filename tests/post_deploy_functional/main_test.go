// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package test

import (
	"testing"

	"github.com/launchbynttdata/lcaf-component-terratest/lib"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/launchbynttdata/tf-aws-module_primitive-route53_record/tests/testimpl"
)

const (
	testConfigsExamplesFolderDefault     = "../../examples/complete"
	testConfigsExamplesFolderMinProvider = "../../examples/min_provider"
	infraTFVarFileNameDefault            = "test.tfvars"
	infraTFVarFileLatency                = "test_latency.tfvars"
)

func TestRoute53RecordComplete(t *testing.T) {
	ctx := types.CreateTestContextBuilder().
		SetTestConfig(&testimpl.ThisTFModuleConfig{}).
		SetTestConfigFolderName(testConfigsExamplesFolderDefault).
		SetTestConfigFileName(infraTFVarFileNameDefault).
		Build()

	lib.RunSetupTestTeardown(t, *ctx, testimpl.TestComposableComplete)
}

func TestRoute53RecordCompleteLatencyRouting(t *testing.T) {
	ctx := types.CreateTestContextBuilder().
		SetTestConfig(&testimpl.ThisTFModuleConfig{}).
		SetTestConfigFolderName(testConfigsExamplesFolderDefault).
		SetTestConfigFileName(infraTFVarFileLatency).
		Build()

	lib.RunSetupTestTeardown(t, *ctx, testimpl.TestComposableComplete)
}

func TestRoute53RecordCompleteMinProvider(t *testing.T) {
	ctx := types.CreateTestContextBuilder().
		SetTestConfig(&testimpl.ThisTFModuleConfig{}).
		SetTestConfigFolderName(testConfigsExamplesFolderMinProvider).
		SetTestConfigFileName(infraTFVarFileNameDefault).
		Build()

	lib.RunSetupTestTeardown(t, *ctx, testimpl.TestComposableComplete)
}

func TestRoute53RecordCompleteLatencyRoutingMinProvider(t *testing.T) {
	ctx := types.CreateTestContextBuilder().
		SetTestConfig(&testimpl.ThisTFModuleConfig{}).
		SetTestConfigFolderName(testConfigsExamplesFolderMinProvider).
		SetTestConfigFileName(infraTFVarFileLatency).
		Build()

	lib.RunSetupTestTeardown(t, *ctx, testimpl.TestComposableComplete)
}
