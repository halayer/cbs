import sys
sys.path.insert(0, "../bindings")
import cbs

class Test(cbs.Component):
    def is_in_addr_space(*args): return 1
    def read(*args): print("py_read"); return 0
    def write(*args): print("py_write"); return 0

bus = cbs.Bus()
bus.debug = sys.stdout
comp = Test(True)

bus.attach_component(comp)
bus.read(1, 2)
