
// Converts an arbitrary block of code into a Verilog string
`define PRIM_STRINGIFY(__x) `"__x`"

// ASSERT_ERROR logs an error message with either `uvm_error or with $error.
//
// This somewhat duplicates `DV_ERROR macro defined in hw/dv/sv/dv_utils/dv_macros.svh. The reason
// for redefining it here is to avoid creating a dependency.
`define ASSERT_ERROR(__name)                                                             \
`ifdef UVM                                                                               \
  uvm_pkg::uvm_report_error("ASSERT FAILED", `PRIM_STRINGIFY(__name), uvm_pkg::UVM_NONE, \
                            `__FILE__, `__LINE__, "", 1);                                \
`else                                                                                    \
  $error("%0t: (%0s:%0d) [%m] [ASSERT FAILED] %0s", $time, `__FILE__, `__LINE__,         \
         `PRIM_STRINGIFY(__name));                                                       \
`endif


// Formal tools will ignore the initial construct, so use static assertion as a workaround.
// This workaround terminates design elaboration if the __prop predict is false.
// It calls $fatal() with the first argument equal to 2, it outputs the statistics about the memory
// and CPU time.
`define ASSERT_INIT(__name, __prop)                                                  \
`ifdef FPV_ON                                                                        \
  if (!(__prop)) $fatal(2, "Fatal static assertion [%s]: (%s) is not true.",         \
                        (__name), (__prop));                                         \
`else                                                                                \
  initial begin                                                                      \
    __name: assert (__prop)                                                          \
      else begin                                                                     \
        `ASSERT_ERROR(__name)                                                        \
      end                                                                            \
  end                                                                                \
`endif



// Interface: pins_if
// Description: Pin interface for driving and sampling individual pins such as interrupts, alerts
// and gpios.
`ifndef SYNTHESIS

interface pins_if #(
  parameter int Width = 1,
  parameter bit [8*4-1:0] PullStrength = "Pull"
) (
  inout [Width-1:0] pins
);

  `ASSERT_INIT(PullStrengthParamValid, PullStrength inside {"Weak", "Pull"})

  logic [Width-1:0] pins_o;       // value to be driven out
  bit   [Width-1:0] pins_oe = '0; // output enable
  bit   [Width-1:0] pins_pd = '0; // pull down enable
  bit   [Width-1:0] pins_pu = '0; // pull up enable

  // function to set pin output enable for specific pin (useful for single pin interface)
  function automatic void drive_en_pin(int idx = 0, bit val);
    pins_oe[idx] = val;
  endfunction

  // function to set pin output enable for all pins
  function automatic void drive_en(bit [Width-1:0] val);
    pins_oe = val;
  endfunction

  // function to drive a specific pin with a value (useful for single pin interface)
  function automatic void drive_pin(int idx = 0, logic val);
    pins_oe[idx] = 1'b1;
    pins_o[idx] = val;
  endfunction // drive_pin

  // function to drive all pins
  function automatic void drive(logic [Width-1:0] val);
    pins_oe = {Width{1'b1}};
    pins_o = val;
  endfunction // drive

  // function to drive all pull down values
  function automatic void set_pulldown_en(bit [Width-1:0] val);
    pins_pd = val;
  endfunction // set_pulldown_en

  // function to drive all pull up values
  function automatic void set_pullup_en(bit [Width-1:0] val);
    pins_pu = val;
  endfunction // set_pullup_en

  // function to drive the pull down value on a specific pin
  function automatic void set_pulldown_en_pin(int idx = 0, bit val);
    pins_pd[idx] = val;
  endfunction // set_pulldown_en_pin

  // function to drive the pull up value on a specific pin
  function automatic void set_pullup_en_pin(int idx = 0, bit val);
    pins_pu[idx] = val;
  endfunction // set_pullup_en_pin

  // function to sample a specific pin (useful for single pin interface)
  function automatic logic sample_pin(int idx = 0);
    return pins[idx];
  endfunction

  // function to sample all pins
  function automatic logic [Width-1:0] sample();
    return pins;
  endfunction

  // Fully disconnect this interface, including the pulls.
  function automatic void disconnect();
    pins_oe = {Width{1'b0}};
    pins_pu = {Width{1'b0}};
    pins_pd = {Width{1'b0}};
  endfunction

  // make connections
  for (genvar i = 0; i < Width; i++) begin : gen_each_pin
`ifdef VERILATOR
    assign pins[i] = pins_oe[i] ? pins_o[i] :
                     pins_pu[i] ? 1'b1 :
                     pins_pd[i] ? 1'b0 : 1'bz;
`else
    // Drive the pin based on whether pullup / pulldown is enabled.
    //
    // If output is not enabled, then the pin is pulled up or down with the `PullStrength` strength
    // Pullup has priority over pulldown.
    if (PullStrength == "Pull") begin : gen_pull_strength_pull
      assign (pull0, pull1) pins[i] = ~pins_oe[i] ? (pins_pu[i] ? 1'b1 :
                                                     pins_pd[i] ? 1'b0 : 1'bz) : 1'bz;
    end : gen_pull_strength_pull
    else if (PullStrength == "Weak") begin : gen_pull_strength_weak
      assign (weak0, weak1) pins[i] = ~pins_oe[i] ? (pins_pu[i] ? 1'b1 :
                                                     pins_pd[i] ? 1'b0 : 1'bz) : 1'bz;
    end : gen_pull_strength_weak

    // If output enable is 1, strong driver assigns pin to 'value to be driven out';
    // the external strong driver can still affect pin, if exists.
    // Else if output enable is 0, weak pullup or pulldown is applied to pin.
    // By doing this, we make sure that weak pullup or pulldown does not override
    // any 'x' value on pin, that may result due to conflicting values
    // between 'value to be driven out' and the external driver's value.
    assign pins[i] = pins_oe[i] ? pins_o[i] : 1'bz;
`endif
  end : gen_each_pin

endinterface
`endif
