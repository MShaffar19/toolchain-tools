## Copyright [2017-2018] UMR MISTEA INRA, UMR LEPSE INRA,                ##
##                       UMR AGAP CIRAD, EPI Virtual Plants Inria        ##
## Copyright [2015-2016] UMR AGAP CIRAD, EPI Virtual Plants Inria        ##
##                                                                       ##
## This file is part of the StatisKit project. More information can be   ##
## found at                                                              ##
##                                                                       ##
##     http://statiskit.rtfd.io                                          ##
##                                                                       ##
## The Apache Software Foundation (ASF) licenses this file to you under  ##
## the Apache License, Version 2.0 (the "License"); you may not use this ##
## file except in compliance with the License. You should have received  ##
## a copy of the Apache License, Version 2.0 along with this file; see   ##
## the file LICENSE. If not, you may obtain a copy of the License at     ##
##                                                                       ##
##     http://www.apache.org/licenses/LICENSE-2.0                        ##
##                                                                       ##
## Unless required by applicable law or agreed to in writing, software   ##
## distributed under the License is distributed on an "AS IS" BASIS,     ##
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       ##
## mplied. See the License for the specific language governing           ##
## permissions and limitations under the License.                        ##

import sys
import os
from SCons.Script import AddOption, GetOption
    
def exists(env):
    return True

def generate(env, **kwargs):
    if not 'prefix' in env['TOOLS'][:-1]:
        env.Tool('system')
        SYSTEM = env['SYSTEM']
        sysprefix = sys.prefix
        if SYSTEM == 'win':
            sysprefix = os.path.join(sysprefix, 'Library')

        AddOption('--prefix',
                      dest    = 'prefix',
                      type    = 'string',
                      nargs   = 1,
                      action  = 'store',
                      metavar = 'DIR',
                      help    = 'installation prefix',
                      default = sysprefix)
        
        env['PREFIX'] = GetOption('prefix')
        env['BUILD_PREFIX'] = os.environ.get('BUILD_PREFIX', '$PREFIX')