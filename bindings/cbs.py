import sys
import os
import ctypes
import _ctypes


# --------- C STUFF ---------

class _FILE(ctypes.Structure): pass      # Dummy FILE structure
_FILE_p = ctypes.POINTER(_FILE)


class _Component(ctypes.Structure):

    _fields_ = [
        ("has_addr_space", ctypes.c_int),   # Indicates whether the component has any address space.

        # CALLBACK FUNCTIONS: (To be implemented by the component)
        ("is_in_addr_space", ctypes.CFUNCTYPE(ctypes.c_int,
                                              ctypes.c_void_p,  # inst
                                              ctypes.c_uint64)),# addr
            # Returns 1 when the given address is within the component's address space.
        
        ("read", ctypes.CFUNCTYPE(ctypes.c_int,
                                  ctypes.c_void_p,  # inst
                                  ctypes.c_uint64,  # addr
                                  ctypes.c_int,     # byte_size
                                  ctypes.c_void_p)),# dst
            # Copies byte_size bytes of data from the component's address space to dst.
        ("write", ctypes.CFUNCTYPE(ctypes.c_int,
                                   ctypes.c_void_p,     # inst
                                   ctypes.c_uint64,     # addr
                                   ctypes.c_int,        # byte_size
                                   ctypes.c_void_p)),   # src

        ("inft", ctypes.POINTER(ctypes.c_void_p)),  # Interface. Here, the implementer can implement additional
            # function(alities) of the component aside from the standard read and write. Though to use them
            # properly, the user must have an agreement with the implementer what these are
            # (preferably a header file), since this library does not provide a standard for that.
            # Can be NULL.

        ("inst", ctypes.c_void_p),  # Component instance, which is passed to the callback functions. Can be NULL.

        ("next", ctypes.c_void_p)   # Next list element. MUST NOT BE SET BY USER/IMPLEMENTER.
    ]
_Component_p = ctypes.POINTER(_Component)


class _Bus(ctypes.Structure):

    _fields_ = [
        ("first", ctypes.POINTER(_Component)),  # Pointer to the first component
        ("last", ctypes.POINTER(_Component)),   # Pointer to the last component
        ("comp_amount", ctypes.c_int),          # Total amount of components

        ("debug", _FILE_p)      # Debug handle. If not NULL, log messages will be written to this handle.
    ]
_Bus_p = ctypes.POINTER(_Bus)
    

if sys.platform == "win32":
    _fdopen = ctypes.cdll.msvcrt._fdopen
    _cbs = ctypes.CDLL(os.path.join(os.path.dirname(__file__), "cbs.dll"))
else:
    _cbs = ctypes.CDLL(os.path.join(os.path.dirname(__file__), "cbs.so"))
    try: _fdopen = ctypes.cdll.libc.fdopen
    except: _fdopen = ctypes.CDLL("libc.so").fdopen
_fdopen.restype = _FILE_p


unload = lambda: _ctypes.FreeLibrary(_cbs._handle)

_cbs.Bus_attachComponent.argtypes = [_Bus_p, _Component_p]
_cbs.Bus_attachComponent.restype = None

_cbs.Bus_detachComponent.argtypes = [_Bus_p, _Component_p]
_cbs.Bus_detachComponent.restype = ctypes.c_int

_cbs.Bus_findComponentByAddr.argtypes = [_Bus_p, ctypes.c_uint64]
_cbs.Bus_findComponentByAddr.restype = _Component_p

_cbs.Bus_read.argtypes = [_Bus_p, ctypes.c_uint64, ctypes.c_int, ctypes.c_void_p]
_cbs.Bus_read.restype = ctypes.c_int

_cbs.Bus_write.argtypes = [_Bus_p, ctypes.c_uint64, ctypes.c_int, ctypes.c_void_p]
_cbs.Bus_write.restype = ctypes.c_int


class Component(object):    # This class is exclusively to derive from!

    def __init__(self, has_addr_space):
        self._struct = _Component(
            has_addr_space,
            _Component._fields_[1][1](self.is_in_addr_space),
            _Component._fields_[2][1](self.read),
            _Component._fields_[3][1](self.write)
        )
        self._inst = ctypes.byref(self._struct)


class Bus(object):

    def __init__(self):
        self._struct = _Bus()
        self._inst = ctypes.byref(self._struct)
    
    def __repr__(self):
        return "<Component {}>".format(self._inst)

    @staticmethod
    def from_reference(ref):
        cls = object.__new__(Bus)
        cls._inst = ref

        return cls

    def attach_component(self, comp):
        if isinstance(comp, Component): comp = comp._inst
        _cbs.Bus_attachComponent(self._inst, comp)
    
    def detach_component(self, comp):
        arg = comp
        if isinstance(arg, Component): arg = comp._inst
        ret = _cbs.Bus_detachComponent(self._inst, arg)
        
        if ret != 0:
            raise IndexError("Component {} not found.".format(comp))

    def find_component_by_addr(self, addr):
        return _cbs.Bus_findComponentByAddr(self._inst, addr)


    def read(self, addr, byte_size):
        buf = ctypes.c_buffer(b"", size=byte_size)

        _cbs.Bus_read(self._inst, addr, byte_size, buf)

        return buf.raw

    def write(self, addr, byte_size, data):
        _cbs.Bus_write(self._inst, addr, byte_size, data)

    def debug(self, debug_handle):
        file = _fdopen(debug_handle.fileno(), b"w")
        self._struct.debug = file

    debug = property(fset=debug)

    @property
    def reference(self):
        return self._inst
