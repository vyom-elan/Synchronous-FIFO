---
title: "FIFO Checklist"
---

## Verification Checklist

### V1

 Type         | Item                                  | Resolution  | Note/Collaterals
--------------|---------------------------------------|-------------|------------------
Documentation | [DV_DOC_DRAFT_COMPLETED][]            | Not Started | [FIFO DV document](dv/index.md)
Documentation | [TESTPLAN_COMPLETED][]                | Done        | [FIFO Testplan](../data/fifo_testplan.md#testplan)
Testbench     | [TB_TOP_CREATED][]                    | Done        |
Testbench     | [SIM_TB_ENV_CREATED][]                | Done        |
Testbench     | [TB_GEN_AUTOMATED][]                  | Done        |
Tests         | [SIM_SMOKE_TEST_PASSING][]            | Not Started |
Tool Setup    | [SIM_ALT_TOOL_SETUP][]                | Not Started |
Regression    | [SIM_SMOKE_REGRESSION_SETUP][]        | Not Started |
Regression    | [SIM_NIGHTLY_REGRESSION_SETUP][]      | Not Started |
Coverage      | [SIM_COVERAGE_MODEL_ADDED][]          | Not Started |
Code Quality  | [TB_LINT_SETUP][]                     | Not Started |
Integration   | [PRE_VERIFIED_SUB_MODULES_V1][]       | Not Started |
Review        | [DESIGN_SPEC_REVIEWED][]              | Not Started |
Review        | [TESTPLAN_REVIEWED][]                 | Not Started |
Review        | [STD_TEST_CATEGORIES_PLANNED][]       | Not Started | Exception (?)
Review        | [V2_CHECKLIST_SCOPED][]               | Not Started |

[DV_DOC_DRAFT_COMPLETED]:             ../../getting_started/checklist.md#dv_doc_draft_completed
[TESTPLAN_COMPLETED]:                 ../../getting_started/checklist.md#testplan_completed
[TB_TOP_CREATED]:                     ../../getting_started/checklist.md#tb_top_created
[SIM_TB_ENV_CREATED]:                 ../../getting_started/checklist.md#sim_tb_env_created
[TB_GEN_AUTOMATED]:                   ../../getting_started/checklist.md#tb_gen_automated
[SIM_SMOKE_TEST_PASSING]:             ../../getting_started/checklist.md#sim_smoke_test_passing
[SIM_ALT_TOOL_SETUP]:                 ../../getting_started/checklist.md#sim_alt_tool_setup
[SIM_SMOKE_REGRESSION_SETUP]:         ../../getting_started/checklist.md#sim_smoke_regression_setup
[SIM_NIGHTLY_REGRESSION_SETUP]:       ../../getting_started/checklist.md#sim_nightly_regression_setup
[SIM_COVERAGE_MODEL_ADDED]:           ../../getting_started/checklist.md#sim_coverage_model_added
[TB_LINT_SETUP]:                      ../../getting_started/checklist.md#tb_lint_setup
[PRE_VERIFIED_SUB_MODULES_V1]:        ../../getting_started/checklist.md#pre_verified_sub_modules_v1
[DESIGN_SPEC_REVIEWED]:               ../../getting_started/checklist.md#design_spec_reviewed
[TESTPLAN_REVIEWED]:                  ../../getting_started/checklist.md#testplan_reviewed
[STD_TEST_CATEGORIES_PLANNED]:        ../../getting_started/checklist.md#std_test_categories_planned
[V2_CHECKLIST_SCOPED]:                ../../getting_started/checklist.md#v2_checklist_scoped

### V2

 Type         | Item                                    | Resolution  | Note/Collaterals
--------------|-----------------------------------------|-------------|------------------
Documentation | [DESIGN_DELTAS_CAPTURED_V2][]           | Not Started |
Documentation | [DV_DOC_COMPLETED][]                    | Not Started |
Testbench     | [FUNCTIONAL_COVERAGE_IMPLEMENTED][]     | Not Started |
Testbench     | [ALL_INTERFACES_EXERCISED][]            | Not Started |
Testbench     | [ALL_ASSERTION_CHECKS_ADDED][]          | Not Started |
Testbench     | [SIM_TB_ENV_COMPLETED][]                | Not Started |
Tests         | [SIM_ALL_TESTS_PASSING][]               | Not Started |
Tests         | [SIM_FW_SIMULATED][]                    | Not Started |
Regression    | [SIM_NIGHTLY_REGRESSION_V2][]           | Not Started |
Coverage      | [SIM_CODE_COVERAGE_V2][]                | Not Started |
Coverage      | [SIM_FUNCTIONAL_COVERAGE_V2][]          | Not Started |
Integration   | [PRE_VERIFIED_SUB_MODULES_V2][]         | Not Started |
Issues        | [NO_HIGH_PRIORITY_ISSUES_PENDING][]     | Not Started |
Issues        | [ALL_LOW_PRIORITY_ISSUES_ROOT_CAUSED][] | Not Started |
Review        | [DV_DOC_TESTPLAN_REVIEWED][]            | Not Started |
Review        | [V3_CHECKLIST_SCOPED][]                 | Not Started |

[DESIGN_DELTAS_CAPTURED_V2]:          ../../getting_started/checklist.md#design_deltas_captured_v2
[DV_DOC_COMPLETED]:                   ../../getting_started/checklist.md#dv_doc_completed
[FUNCTIONAL_COVERAGE_IMPLEMENTED]:    ../../getting_started/checklist.md#functional_coverage_implemented
[ALL_INTERFACES_EXERCISED]:           ../../getting_started/checklist.md#all_interfaces_exercised
[ALL_ASSERTION_CHECKS_ADDED]:         ../../getting_started/checklist.md#all_assertion_checks_added
[SIM_TB_ENV_COMPLETED]:               ../../getting_started/checklist.md#sim_tb_env_completed
[SIM_ALL_TESTS_PASSING]:              ../../getting_started/checklist.md#sim_all_tests_passing
[SIM_FW_SIMULATED]:                   ../../getting_started/checklist.md#sim_fw_simulated
[SIM_NIGHTLY_REGRESSION_V2]:          ../../getting_started/checklist.md#sim_nightly_regression_v2
[SIM_CODE_COVERAGE_V2]:               ../../getting_started/checklist.md#sim_code_coverage_v2
[SIM_FUNCTIONAL_COVERAGE_V2]:         ../../getting_started/checklist.md#sim_functional_coverage_v2
[PRE_VERIFIED_SUB_MODULES_V2]:        ../../getting_started/checklist.md#pre_verified_sub_modules_v2
[NO_HIGH_PRIORITY_ISSUES_PENDING]:    ../../getting_started/checklist.md#no_high_priority_issues_pending
[ALL_LOW_PRIORITY_ISSUES_ROOT_CAUSED]:../../getting_started/checklist.md#all_low_priority_issues_root_caused
[DV_DOC_TESTPLAN_REVIEWED]:           ../../getting_started/checklist.md#dv_doc_testplan_reviewed
[V3_CHECKLIST_SCOPED]:                ../../getting_started/checklist.md#v3_checklist_scoped

### V3

 Type         | Item                              | Resolution  | Note/Collaterals
--------------|-----------------------------------|-------------|------------------
Documentation | [DESIGN_DELTAS_CAPTURED_V3][]     | Not Started |
Regression    | [SIM_NIGHTLY_REGRESSION_AT_V3][]  | Not Started |
Coverage      | [SIM_CODE_COVERAGE_AT_100][]      | Not Started |
Coverage      | [SIM_FUNCTIONAL_COVERAGE_AT_100][]| Not Started |
Code Quality  | [ALL_TODOS_RESOLVED][]            | Not Started |
Code Quality  | [NO_TOOL_WARNINGS_THROWN][]       | Not Started |
Code Quality  | [TB_LINT_COMPLETE][]              | Not Started |
Integration   | [PRE_VERIFIED_SUB_MODULES_V3][]   | Not Started |
Issues        | [NO_ISSUES_PENDING][]             | Not Started |
Review        | Reviewer(s)                       | Not Started |
Review        | Signoff date                      | Not Started |

[DESIGN_DELTAS_CAPTURED_V3]:     ../../getting_started/checklist.md#design_deltas_captured_v3
[SIM_NIGHTLY_REGRESSION_AT_V3]:  ../../getting_started/checklist.md#sim_nightly_regression_at_v3
[SIM_CODE_COVERAGE_AT_100]:      ../../getting_started/checklist.md#sim_code_coverage_at_100
[SIM_FUNCTIONAL_COVERAGE_AT_100]:../../getting_started/checklist.md#sim_functional_coverage_at_100
[ALL_TODOS_RESOLVED]:            ../../getting_started/checklist.md#all_todos_resolved
[NO_TOOL_WARNINGS_THROWN]:       ../../getting_started/checklist.md#no_tool_warnings_thrown
[TB_LINT_COMPLETE]:              ../../getting_started/checklist.md#tb_lint_complete
[PRE_VERIFIED_SUB_MODULES_V3]:   ../../getting_started/checklist.md#pre_verified_sub_modules_v3
[NO_ISSUES_PENDING]:             ../../getting_started/checklist.md#no_issues_pending

