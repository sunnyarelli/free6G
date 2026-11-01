.PHONY: deps all core gtp5g ran ue sim run-core run-zmq run-sim clean
deps:     ; ./scripts/install-deps.sh
all:      ; ./scripts/build.sh all
core:     ; ./scripts/build.sh core
gtp5g:    ; ./scripts/build.sh gtp5g
ran:      ; ./scripts/build.sh ran
ue:       ; ./scripts/build.sh ue
sim:      ; ./scripts/build.sh sim
run-core: ; ./scripts/run-core.sh
run-zmq:  ; ./scripts/run-ran-ue-zmq.sh
run-sim:  ; ./scripts/run-sim.sh
clean:    ; rm -rf build && $(MAKE) -C 6g-core clean && $(MAKE) -C 6g-sim clean
