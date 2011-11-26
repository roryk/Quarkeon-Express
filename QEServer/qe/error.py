#!/usr/bin/env python

class DBRowsToDictError (Exception):
    pass

class QEPermissionsError (Exception):
    pass

class QEIntegrityError (Exception):
    pass

class QENotLoggedInError (Exception):
    pass
