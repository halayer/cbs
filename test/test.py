import sys
sys.path.insert(0, "../bindings")
import cbs
import ctypes

if sys.platform == "win32":
    memset = ctypes.cdll.msvcrt.memset
else:
    try: memset = ctypes.cdll.libc.memset
    except: memset = ctypes.CDLL("libc.so").memset

memset.argtypes = [ctypes.c_void_p, ctypes.c_char, ctypes.c_size_t]


class Test(cbs.Component):
    def is_in_addr_space(*args): return 1
    
    def read(self, inst, addr, byte_size, dst):
        print("py_read")
        
        memset(dst, ctypes.c_char(0x41), byte_size)
        
        return 0
        
    def write(*args): print("py_write"); return 0

bus = cbs.Bus()
bus.debug = sys.stdout
comp = Test(True)

bus.attach_component(comp)
bus.read(1, 2)

cbs.unload()
