#!/bin/bash

#  ******************************************************************************
# https://github.com/cloudfstrife/note/blob/develop/golang/install_vs_code_golang_ext_tools.sh
#  Linux安装 Visual Studio Code 的go语言插件扩展工具的shell
#  
#  ****    脚本前置条件    ****
#  * 安装好Go环境
#  * 配置好GOPATH环境变量，目前只支持一个目录
#  * 安装好git
#  
#  ****    脚本后置操作    ****
#  sudo cp $GOPATH/bin/* $GOROOT/bin
#  gometalinter --install
#
#  ******************************************************************************

# git项目URL后缀
GIT_POSTFIX=".git"
# git项目URL后缀
GIT_PREFIX="https://"
# build函数中去除的部分
REMOVE="/..."

# -------------------------------------------------------------------------------
#  处理错误
#  参数1 上一命令返回状态，一般为$?
#  参数2 任务说明
# -------------------------------------------------------------------------------
function showError(){
    if [ $1 = "0" ]; then
        log "SUCCESS" "$2"
    else
        log "ERROR" "$2"
        exit 1
    fi 
}

# -------------------------------------------------------------------------------
#  日志输出
#  参数1 日志级别
#  参数2 日志内容
# -------------------------------------------------------------------------------
function log(){
    printf "%s [ %-7s ] : %s\n" "$(date '+%F %T')" "$1" "$2"
}

# -------------------------------------------------------------------------------
# 克隆（拉取）git 项目指定分支到指定目录
# github https://github.com/golang/tools.git "$GOPATH/src/golang.org/x/tools" master
# -------------------------------------------------------------------------------
function github(){
    if [ -z "$3" ] ; then
        showError "1" "github function invoked without enough parameter"
    fi

    

    if [ ! -d $2 ]; then
        log "START" "CLONE $1"
        git clone -q $1 $2
        showError $? "CLONE $1"
        cd $2
        git checkout -q $3
        showError $? "CHECKOUT $1"
        log "DONE" "CLONE $1"
    else
        cd $2
        if [ ! -d "$2/.git" ]; then
            showError "1" "target folder is not a git project folder"
        fi
        GIT_ALICE_NAME="$(git remote show)"
        GIT_REMOTE_URL="$(git remote get-url --all $GIT_ALICE_NAME)"

        if [ "$1" != "$GIT_REMOTE_URL"  ]; then
            showError "1" "git remote url do not match"
        fi

        log "START" "PULL $1"
        git checkout -q $3
        showError $? "Switch to $3 branch"
        git pull -q $GIT_ALICE_NAME $3
        showError $? "Pulling code from remote git branch $3"
        log "DONE" "PULL $1"    
    fi
    echo ""
}

# -------------------------------------------------------------------------------
# 检查Go环境变量设置是否正确
# -------------------------------------------------------------------------------
function check_go_env(){
    if [ -z "$GOROOT" ] ;then
        showError "1" "Environment variables [GOROOT] NOT set"
    fi

    if [ ! -f "$GOROOT/bin/go" ] ;then
        showError "1" "Environment variables [GOROOT] NOT a go install PATH"
    fi

    if [ -z "$GOPATH" ] ;then
        showError "1" "Environment variables [GOPATH] NOT set"
    fi    
}

# -------------------------------------------------------------------------------
# 构建 go 扩展依赖工具
# 参数一：工具名称
# 参数二：github URL
# 示例：
# build gocode github.com/mdempsky/gocode
# -------------------------------------------------------------------------------
function build(){
    if [ -z "$2" ] ; then
        showError "1" "build function invoked without enough parameter"
    fi
    GIT_URL="$GIT_PREFIX${2%%$REMOVE}$GIT_POSTFIX"
    github $GIT_URL $GOPATH/src/$2 master
    go build -o 
}

# -------------------------------------------------------------------------------
# 环境变量检查
# -------------------------------------------------------------------------------
check_go_env

# -------------------------------------------------------------------------------
# golang
# -------------------------------------------------------------------------------
log "START" "FETCH golang build-in tools"
github https://github.com/golang/tools.git "$GOPATH/src/golang.org/x/tools" master
echo ""

github https://github.com/golang/net.git "$GOPATH/src/golang.org/x/net" master
echo ""

github https://github.com/golang/lint.git "$GOPATH/src/golang.org/x/lint" master
log "DONE" "FETCH golang build-in tools"
echo ""

# -------------------------------------------------------------------------------
# https://github.com/Microsoft/vscode-go/blob/master/src/goInstallTools.ts
# -------------------------------------------------------------------------------

build gocode github.com/mdempsky/gocode
build gocode-gomod github.com/stamblerre/gocode
build gopkgs github.com/uudashr/gopkgs/cmd/gopkgs
build go-outline github.com/ramya-rao-a/go-outline
build go-symbols github.com/acroca/go-symbols
build gomodifytags github.com/fatih/gomodifytags
build goplay github.com/haya14busa/goplay/cmd/goplay
build impl github.com/josharian/impl
build gotype-live github.com/tylerb/gotype-live
build godef github.com/rogpeppe/godef
build godef-gomod github.com/ianthehat/godef
build gogetdoc github.com/zmb3/gogetdoc
build goreturns github.com/sqs/goreturns
build goformat winterdrache.de/goformat/goformat
build gotests github.com/cweill/gotests/...
build gometalinter github.com/alecthomas/gometalinter
build megacheck honnef.co/go/tools/...
build golangci-lint github.com/golangci/golangci-lint/cmd/golangci-lint
build revive github.com/mgechev/revive
build go-langserver github.com/sourcegraph/go-langserver
build dlv github.com/derekparker/delve/cmd/dlv
build fillstruct github.com/davidrjenni/reftools/cmd/fillstruct


guru golang.org/x/tools/cmd/guru
gorename golang.org/x/tools/cmd/gorename
golint golang.org/x/lint/golint
goimports golang.org/x/tools/cmd/goimports