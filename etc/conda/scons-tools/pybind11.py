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

import itertools
import os
import sysconfig
try:
    from path import Path
except:
    from path import path as Path
    
def exists(env):
    return True

def generate(env):
    """Add Builders and construction variables to the Environment."""
    
    if not 'pybind11' in env['TOOLS'][:-1]:
        env.Tool('system')
        env.Tool('textfile')

        PYTHON_VERSION = sysconfig.get_python_version()

        def PyBind11Extension(env, target, sources, preserve_egg_dir=False):
            # Code to build "target" from "source"
            SP_DIR = env['SP_DIR']
            SYSTEM = env['SYSTEM']
            parents = []
            if not preserve_egg_dir:
                parent = os.path.dirname(env.File(target).srcnode().abspath)
                while os.path.exists(os.path.join(parent, '__init__.py')):
                    parents.append(os.path.basename(parent))
                    parent = os.path.dirname(parent)
                if parents:
                    target = os.path.join(os.path.join(*reversed(parents)), os.path.basename(target))
                else:
                    target = os.path.basename(target)
                if not SYSTEM == 'win':
                    target += '.so'
                    target = env.File(os.path.join(SP_DIR, target))
                else:
                    target += '.pyd'
                    target = env.File(target)
            else:
                if not SYSTEM == 'win':
                    target += '.so'
                    target = env.File(target).srcnode()
                else:
                    target += '.pyd'
                    target = env.File(target)
            targets = list(itertools.chain(*[env.SharedObject(None, source) for source in sources  if source.suffix in ['.cpp', '.cxx', '.c++']]))
            sources = [source for source in sources if source.suffix == '.h']
            if len(sources) == 1 and not SYSTEM == 'win':
                env.AppendUnique(CCFLAGS = ['-Winvalid-pch'])
                cmd = env.subst('$CXX') + ' -o $TARGET -x c++-header -c -fPIC ' + env.subst('$SHCXXFLAGS $CCFLAGS $_CCCOMCOM').replace('-x c++', '') + ' $SOURCE'
                cmd = env.Command(sources[0].target_from_source('', '.h.gch'), sources[0], cmd)
                env.Depends(targets, cmd)
                if SYSTEM == 'osx':
                    env['CXX'] += " -include " + sources[0].target_from_source('', '.h').abspath
            env.Depends(target, targets)
            if SYSTEM == 'win':
                response_file = os.path.abspath('response_file.rsp')
                with open(response_file, 'w') as filehandler:
                    filehandler.write(" ".join([tgt.abspath.replace('/','\\') for tgt in targets]))
                env.Append(LINKFLAGS = '@"' + response_file + '"')
            else:
                response = env.Textfile('response_file.rsp',
                         [tgt.abspath.replace('\\','/') for tgt in targets],
                         LINESEPARATOR=" ")
                env.Append(LINKFLAGS = '@' + response[0].abspath)
                env.Depends(target, response)
            if SYSTEM == 'win':
                pyd, lib, exp = env.SharedLibrary(target, [], SHLIBPREFIX='',
                                                  SHLIBSUFFIX = '.pyd')
                if preserve_egg_dir:
                    return env.Install(os.path.dirname(target.srcnode().abspath), pyd)
                else:
                    return env.Install(os.path.join(SP_DIR, Path(target).parent), pyd)
            elif SYSTEM == 'osx':
                return env.LoadableModule(target, [], SHLIBPREFIX='',
                                          SHLINKFLAGS='$LINKFLAGS -bundle',
                                          FRAMEWORKSFLAGS='-flat_namespace -undefined suppress')
            else:
                return env.LoadableModule(target, [], SHLIBPREFIX='')

        env.AddMethod(PyBind11Extension)
        env.Tool('python')