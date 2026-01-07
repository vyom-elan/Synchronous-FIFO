# UVM Verification of Synchronous FIFO using OpenTitan uvmdvgen

## Overview

This repository contains a UVM-based verification environment for a **Synchronous FIFO** design, generated using the OpenTitan `uvmdvgen` toolchain.  
The environment follows OpenTitan / lowRISC DV guidelines, enabling scalable, reusable, and coverage-driven verification.

The FIFO operates in a single clock domain and supports standard FIFO control and status signaling.

---

## Key Features

- Generated using OpenTitan `uvmdvgen`
- UVM 1.2 compliant architecture
- Constrained-random stimulus generation
- Functional coverage model
- Scoreboard-based checking
- Assertion-based protocol validation
- Easily configurable FIFO depth and width

---

## FIFO Specification 

| Parameter | Description |
|---------|-------------|
| Clock | Single synchronous clock |
| Reset | Active-low synchronous reset |
| Data Width | Parameterized |
| Depth | Parameterized |
| Write Enable | `wr_en` |
| Write Data | `wr_data` |
| Read Enable | `rd_en` |
| Read Data | `rd_data` |
| Status Flags | `full`, `empty` |

---

## Repository Structure

```text

fifo-dv/                                 # This is the repository root — referred to as $REPO_TOP   
├── hw
│   ├── data
│       └── common_project_cfg.hjson     # Shared DV configuration file for all IPs.
│   ├── dv/                              # Base DV utilities, templates, and tool integration
│   └── ip
│       └── fifo
│           ├── data
│           │   └── fifo_testplan.hjson
│           ├── doc
│           │   ├── checklist.md         # Verification checklist for FIFO IP (functional coverage 
│           │   ├                        # completion, regression pass rate, etc.).
│           │   └── dv
│           │       └── index.md         # Documentation entry point
│           ├── dv                       # The main testbench directory
│           │   ├── cov
│           │   ├── env/                 # UVM environment files (cfg, scoreboard, etc.)
│           │   │   └── seq_lib/         # Sequence library with different stimulus patterns
│           │   ├── fifo_agent/          # UVM agent files (interface, transaction, driver, monitor, agent)
│           │   ├── fifo_sim_cfg.hjson   # DvSim configuration file controlling build/run flow
│           │   ├── fifo_sim.core        # FuseSoC core file for the simulation setup
│           │   ├── sva/                 # Bind file for SVA connections to DUT
│           │   ├── tb.sv                # Top-level UVM testbench wrapper (instantiates DUT + environment)
│           │   └── tests/               # Individual UVM test classes
|           └── rtl                      # FIFO RTL design files (DUT)
│               ├── fifo.sv
│               ├── fifo.core
└── README.md
```


### Assertions

- No write when FIFO is full  
- No read when FIFO is empty  
- Correct full/empty flag behavior  

---

## Tests

| Test Name               | Description                                  |
|------------------------|----------------------------------------------|
| `fifo_smoke_test`      | Basic sanity write/read test                 |
| `fifo_rand_test`       | Randomized read/write traffic                |
| `fifo_full_empty_test` | Stress test for full/empty transitions       |

All tests extend from `fifo_base_test`.

---

## Prerequisites

- Tools - Questa / VCS / Xcelium
- Python 3.x
- OpenTitan repository setup
- `uvmdvgen` available in `PATH`

---
## Quick Start 

**After setting up the tools on your local system/server and configuring environment variables.**

These commands will fully reproduce and run the environment on any compatible CentOS/RHEL-based server.

```bash
# 1. Clone the repository
git clone <repo_url> fifo-dv
cd fifo-dv

# 2. Source the simulator environment (example: Synopsys CSHRC)
source /home/tools/synopsys/bashrc_synopsys
synopsys

# 3. Enable GCC 11 toolchain
scl enable devtoolset-11 bash

# 4. Activate the OpenTitan Python virtual environment
source /opt/venvs/&yourpath*/bin/activate

# 5. Export the repository top
export REPO_TOP=$(pwd)

# 6. Run the FIFO smoke test
/opt/util/dvsim/dvsim.py $REPO_TOP/hw/ip/fifo/dv/fifo_sim_cfg.hjson -i all
```

**Expected Console Output:**
Simulation should compile and execute the FIFO UVM environment successfully.
```
### Simulator: VCS

### Test Results
|  Stage  |  Name  | Tests      |  Max Job Runtime  |  Simulated Time  |  Passing  |  Total  |  Pass Rate  |
|:-------:|:------:|:-----------|:-----------------:|:----------------:|:---------:|:-------:|:-----------:|
|   V1    | smoke  | fifo_smoke |      0.560s       |     7.952us      |     1     |    1    |  100.00 %   |
|   V1    |        | **TOTAL**  |                   |                  |     1     |    1    |  100.00 %   |
|         |        | **TOTAL**  |                   |                  |     1     |    1    |  100.00 %   |


INFO: [FlowCfg] [scratch_path]: [fifo] [/fifo-dv/scratch/main/fifo-sim-vcs]

          [   legend    ]: [Q: queued, D: dispatched, P: passed, F: failed, K: killed, T: total]                     
00:00:18  [    build    ]: [Q: 0, D: 0, P: 1, F: 0, K: 0, T: 1] 100%                                                 
00:00:20  [     run     ]: [Q: 0, D: 0, P: 1, F: 0, K: 0, T: 1] 100%  
```

## Running Other Tests

You can control which tests to run by modifying the `-i` option:

| Command          | Description                                            |
| ---------------- | ------------------------------------------------------ |
| `-i smoke`       | Runs basic functional test (default sanity check).     |
| `-i all`         | Runs all defined testcases from `fifo_testplan.hjson`. |
| `-i <test_name>` | Runs a specific test (e.g. `fifo_full_empty`).         |

Example:

```bash
/opt/util/dvsim/dvsim.py $REPO_TOP/hw/ip/fifo/dv/fifo_sim_cfg.hjson -i all
```

## Coverage Collection

To include code coverage in the run, append the `-c` option:

```bash
/opt/util/dvsim/dvsim.py $REPO_TOP/hw/ip/fifo/dv/fifo_sim_cfg.hjson -i smoke -c
```

After completion, coverage reports and dashboards will be generated under:

```
scratch/main/fifo-sim-vcs/
```

Open the file:

```
scratch/main/reports/hw/ip/fifo/dv/latest/report.html
```

to view interactive coverage results.

## Test Plan and Extensibility

The complete test plan is defined in:

```
hw/ip/fifo/data/fifo_testplan.hjson
```

This file lists all supported tests such as:

* **smoke** – Basic functional connectivity check
* **overflow/underflow** – Boundary condition verification
* **random_stress** – Randomized transaction stress test
* **reset_sequence** – Functional reset during transactions

Users can extend this list with new test entries.
Each entry can be associated with custom sequence classes under `seq_lib/`.

---

## Environment Notes

| Component       | Location                   | Notes                                                                 |
| --------------- | -------------------------- | --------------------------------------------------------------------- |
| **uvmdvgen.py** | `/opt/util/uvmdvgen.py`    | Used to auto-generate the UVM boilerplate (agents, env, tb etc).      |
| **dvsim.py**    | `/opt/util/dvsim/dvsim.py` | OpenTitan simulation automation tool.                                 |
| **Python venv** | `/opt/venvs/opentitan`     | Preinstalled environment containing `dvsim` and dependencies.         |
| **Toolchain**   | `devtoolset-11`            | Required for modern C++ support in simulator compilation.             |
| **Simulator**   | Synopsys VCS (primary)     | Other supported simulators (Xcelium, Questa) can be integrated later. |

## Troubleshooting

| Issue                           | Possible Cause / Fix                                                      |
| ------------------------------- | ------------------------------------------------------------------------- |
| `command not found: dvsim.py`   | Ensure `/opt/util/dvsim` is accessible and sourced correctly.             |
| `ModuleNotFoundError: hjson`    | Check that `/opt/venvs/opentitan` virtual environment is activated.       |
| `Error: FuseSoC core not found` | Verify that `fifo.core` is correctly placed under `hw/ip/fifo/rtl/`. |
| Simulation doesn’t start        | Confirm that `source <path_to_synopsys_cshrc_file>` was executed.              |
| Coverage folder missing         | Run again with the `-c` flag.                                             |

## Development and Extension Workflow

This repository was created using the following steps:

1. Used `uvmdvgen` to create a UVM boilerplate:

   ```bash
   /opt/util/uvmdvgen.py fifo -a -ao hw/ip/fifo/dv/
   /opt/util/uvmdvgen.py fifo -e -eo hw/ip/fifo/ -ea fifo
   ```
2. Integrated the DUT RTL (`fifo.sv`) from the referenced repository into `hw/ip/fifo/rtl/`.
3. Created the `fifo.core` file for FuseSoC integration.
4. Populated interface, agent, scoreboard, and test sequences.
5. Verified with a smoke test.
6. Added multiple tests to `fifo_testplan.hjson`.
7. Automated build, run, and coverage using `dvsim`.

## License & Credits

* **Original DUT RTL and functional reference:**
  [FIFO-Verification](https://github.com/MohamedHussein27/FIFO-Verification)
  >The original repository provided the FIFO RTL and SystemVerilog testbench, from which the DUT and scoreboard concepts were reused and adapted to a UVM environment.

* **Framework & Automation Tools:**
  [OpenTitan DV Framework](https://opentitan.org/)

## Author

**Vyom Pandey** - Demonstration setup to analyse the scope of automation tools and assess the potential of generated testbench for other projects. 
