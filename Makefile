SRC = src/top.v src/alu.v src/alu_control.v src/control.v src/data_mem.v \
      src/instr_mem.v src/mux.v src/pc.v src/registers.v

.PHONY: test clean
test:
	@set -e; \
	for tb in alu alu_control control data_mem instr_mem pc registers top fib; do \
	  echo "== $$tb =="; \
	  iverilog -g2012 -s $${tb}_tb -o $$tb.vvp testbench/$${tb}_tb.v $(SRC); \
	  vvp $$tb.vvp; \
	done

clean:
	rm -f *.vvp *.vcd
