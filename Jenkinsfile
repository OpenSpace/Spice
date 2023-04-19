library('sharedSpace'); // jenkins-pipeline-lib

def url = 'https://github.com/OpenSpace/Spice';
def branch = env.BRANCH_NAME;

//
// Pipeline start
//
parallel linux_gcc_make: {
  if (env.USE_BUILD_OS_LINUX == 'true') {
    node('linux-gcc') {
      stage('linux-gcc-make/scm') {
        deleteDir();
        gitHelper.checkoutGit(url, branch);
      }
      stage('linux-gcc-make/build') {
        compileHelper.build(compileHelper.Make(), compileHelper.Gcc(), '', '', 'build-make');
      }
      cleanWs()
    } // node('linux')
  }
},
linux_gcc_ninja: {
  if (env.USE_BUILD_OS_LINUX == 'true') {
    node('linux-gcc') {
      stage('linux-gcc-ninja/scm') {
        deleteDir();
        gitHelper.checkoutGit(url, branch);
      }
      stage('linux-gcc-ninja/build') {
          compileHelper.build(compileHelper.Ninja(), compileHelper.Gcc(), '', '', 'build-ninja');
      }
      cleanWs()
    } // node('linux')
  }
},
linux_clang_make: {
  if (env.USE_BUILD_OS_LINUX == 'true') {
    node('linux-clang') {
      stage('linux-clang-make/scm') {
        deleteDir();
        gitHelper.checkoutGit(url, branch);
      }
      stage('linux-clang-make/build') {
        compileHelper.build(compileHelper.Make(), compileHelper.Clang(), '', '', 'build-make');
      }
      cleanWs()
    } // node('linux')
  }
},
linux_clang_ninja: {
  if (env.USE_BUILD_OS_LINUX == 'true') {
    node('linux-clang') {
      stage('linux-clang-ninja/scm') {
        deleteDir();
        gitHelper.checkoutGit(url, branch);
      }
      stage('linux-clang-ninja/build') {
          compileHelper.build(compileHelper.Ninja(), compileHelper.Clang(), '', '', 'build-ninja');
      }
      cleanWs()
    } // node('linux')
  }
},
windows_msvc: {
  if (env.USE_BUILD_OS_WINDOWS == 'true') {
    node('windows') {
      stage('windows-msvc/scm') {
        deleteDir();
        gitHelper.checkoutGit(url, branch);
      }
      stage('windows-msvc/build') {
        compileHelper.build(compileHelper.VisualStudio(), compileHelper.VisualStudio(), '', '', 'build-msvc');
      }
      cleanWs()
    } // node('windows')
  }
},
windows_ninja: {
  if (env.USE_BUILD_OS_WINDOWS == 'true') {
    node('windows') {
      stage('windows-ninja/scm') {
        deleteDir();
        gitHelper.checkoutGit(url, branch);
      }
      stage('windows-ninja/build') {
        compileHelper.build(compileHelper.Ninja(), compileHelper.VisualStudio(), '', '', 'build-ninja');
      }
      cleanWs()
    } // node('windows')
  }
},
macos_make: {
  if (env.USE_BUILD_OS_MACOS == 'true') {
    node('macos') {
      stage('macos-make/scm') {
        deleteDir();
        gitHelper.checkoutGit(url, branch);
      }
      stage('macos-make/build') {
          compileHelper.build(compileHelper.Make(), compileHelper.Clang(), '', '', 'build-make');
      }
      cleanWs()
    } // node('osx')
  }
},
macos_ninja: {
  if (env.USE_BUILD_OS_MACOS == 'true') {
    node('macos') {
      stage('macos-xcode/scm') {
        deleteDir();
        gitHelper.checkoutGit(url, branch);
      }
      stage('macos-xcode/build') {
          compileHelper.build(compileHelper.Xcode(), compileHelper.Xcode(), '', '', 'build-xcode');
      }
      cleanWs()
    } // node('osx')
  }
}
