#
#   http-freebsd-static.mk -- Makefile to build Embedthis Http for freebsd
#

NAME                  := http
VERSION               := 6.0.3
PROFILE               ?= static
ARCH                  ?= $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/')
CC_ARCH               ?= $(shell echo $(ARCH) | sed 's/x86/i686/;s/x64/x86_64/')
OS                    ?= freebsd
CC                    ?= gcc
CONFIG                ?= $(OS)-$(ARCH)-$(PROFILE)
BUILD                 ?= build/$(CONFIG)
LBIN                  ?= $(BUILD)/bin
PATH                  := $(LBIN):$(PATH)

ME_COM_COMPILER       ?= 1
ME_COM_EST            ?= 0
ME_COM_LIB            ?= 1
ME_COM_MATRIXSSL      ?= 0
ME_COM_MBEDTLS        ?= 0
ME_COM_MPR            ?= 1
ME_COM_NANOSSL        ?= 0
ME_COM_OPENSSL        ?= 1
ME_COM_OSDEP          ?= 1
ME_COM_PCRE           ?= 1
ME_COM_SSL            ?= 1
ME_COM_VXWORKS        ?= 0
ME_COM_WINSDK         ?= 1

ME_COM_OPENSSL_PATH   ?= "/usr/lib"

ifeq ($(ME_COM_EST),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_LIB),1)
    ME_COM_COMPILER := 1
endif
ifeq ($(ME_COM_OPENSSL),1)
    ME_COM_SSL := 1
endif

CFLAGS                += -g -w
DFLAGS                +=  $(patsubst %,-D%,$(filter ME_%,$(MAKEFLAGS))) -DME_COM_COMPILER=$(ME_COM_COMPILER) -DME_COM_EST=$(ME_COM_EST) -DME_COM_LIB=$(ME_COM_LIB) -DME_COM_MATRIXSSL=$(ME_COM_MATRIXSSL) -DME_COM_MBEDTLS=$(ME_COM_MBEDTLS) -DME_COM_MPR=$(ME_COM_MPR) -DME_COM_NANOSSL=$(ME_COM_NANOSSL) -DME_COM_OPENSSL=$(ME_COM_OPENSSL) -DME_COM_OSDEP=$(ME_COM_OSDEP) -DME_COM_PCRE=$(ME_COM_PCRE) -DME_COM_SSL=$(ME_COM_SSL) -DME_COM_VXWORKS=$(ME_COM_VXWORKS) -DME_COM_WINSDK=$(ME_COM_WINSDK) 
IFLAGS                += "-I$(BUILD)/inc"
LDFLAGS               += 
LIBPATHS              += -L$(BUILD)/bin
LIBS                  += -ldl -lpthread -lm

DEBUG                 ?= debug
CFLAGS-debug          ?= -g
DFLAGS-debug          ?= -DME_DEBUG
LDFLAGS-debug         ?= -g
DFLAGS-release        ?= 
CFLAGS-release        ?= -O2
LDFLAGS-release       ?= 
CFLAGS                += $(CFLAGS-$(DEBUG))
DFLAGS                += $(DFLAGS-$(DEBUG))
LDFLAGS               += $(LDFLAGS-$(DEBUG))

ME_ROOT_PREFIX        ?= 
ME_BASE_PREFIX        ?= $(ME_ROOT_PREFIX)/usr/local
ME_DATA_PREFIX        ?= $(ME_ROOT_PREFIX)/
ME_STATE_PREFIX       ?= $(ME_ROOT_PREFIX)/var
ME_APP_PREFIX         ?= $(ME_BASE_PREFIX)/lib/$(NAME)
ME_VAPP_PREFIX        ?= $(ME_APP_PREFIX)/$(VERSION)
ME_BIN_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/bin
ME_INC_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/include
ME_LIB_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/lib
ME_MAN_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/share/man
ME_SBIN_PREFIX        ?= $(ME_ROOT_PREFIX)/usr/local/sbin
ME_ETC_PREFIX         ?= $(ME_ROOT_PREFIX)/etc/$(NAME)
ME_WEB_PREFIX         ?= $(ME_ROOT_PREFIX)/var/www/$(NAME)
ME_LOG_PREFIX         ?= $(ME_ROOT_PREFIX)/var/log/$(NAME)
ME_SPOOL_PREFIX       ?= $(ME_ROOT_PREFIX)/var/spool/$(NAME)
ME_CACHE_PREFIX       ?= $(ME_ROOT_PREFIX)/var/spool/$(NAME)/cache
ME_SRC_PREFIX         ?= $(ME_ROOT_PREFIX)$(NAME)-$(VERSION)


TARGETS               += $(BUILD)/bin/http-server
TARGETS               += $(BUILD)/bin/http
ifeq ($(ME_COM_SSL),1)
    TARGETS           += $(BUILD)/bin
endif

unexport CDPATH

ifndef SHOW
.SILENT:
endif

all build compile: prep $(TARGETS)

.PHONY: prep

prep:
	@echo "      [Info] Use "make SHOW=1" to trace executed commands."
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@if [ "$(ME_APP_PREFIX)" = "" ] ; then echo WARNING: ME_APP_PREFIX not set ; exit 255 ; fi
	@[ ! -x $(BUILD)/bin ] && mkdir -p $(BUILD)/bin; true
	@[ ! -x $(BUILD)/inc ] && mkdir -p $(BUILD)/inc; true
	@[ ! -x $(BUILD)/obj ] && mkdir -p $(BUILD)/obj; true
	@[ ! -f $(BUILD)/inc/me.h ] && cp projects/http-freebsd-static-me.h $(BUILD)/inc/me.h ; true
	@if ! diff $(BUILD)/inc/me.h projects/http-freebsd-static-me.h >/dev/null ; then\
		cp projects/http-freebsd-static-me.h $(BUILD)/inc/me.h  ; \
	fi; true
	@if [ -f "$(BUILD)/.makeflags" ] ; then \
		if [ "$(MAKEFLAGS)" != "`cat $(BUILD)/.makeflags`" ] ; then \
			echo "   [Warning] Make flags have changed since the last build" ; \
			echo "   [Warning] Previous build command: "`cat $(BUILD)/.makeflags`"" ; \
		fi ; \
	fi
	@echo "$(MAKEFLAGS)" >$(BUILD)/.makeflags

clean:
	rm -f "$(BUILD)/obj/actionHandler.o"
	rm -f "$(BUILD)/obj/auth.o"
	rm -f "$(BUILD)/obj/basic.o"
	rm -f "$(BUILD)/obj/cache.o"
	rm -f "$(BUILD)/obj/chunkFilter.o"
	rm -f "$(BUILD)/obj/client.o"
	rm -f "$(BUILD)/obj/config.o"
	rm -f "$(BUILD)/obj/conn.o"
	rm -f "$(BUILD)/obj/digest.o"
	rm -f "$(BUILD)/obj/dirHandler.o"
	rm -f "$(BUILD)/obj/endpoint.o"
	rm -f "$(BUILD)/obj/error.o"
	rm -f "$(BUILD)/obj/est.o"
	rm -f "$(BUILD)/obj/estLib.o"
	rm -f "$(BUILD)/obj/fileHandler.o"
	rm -f "$(BUILD)/obj/host.o"
	rm -f "$(BUILD)/obj/http-server.o"
	rm -f "$(BUILD)/obj/http.o"
	rm -f "$(BUILD)/obj/monitor.o"
	rm -f "$(BUILD)/obj/mprLib.o"
	rm -f "$(BUILD)/obj/netConnector.o"
	rm -f "$(BUILD)/obj/openssl.o"
	rm -f "$(BUILD)/obj/packet.o"
	rm -f "$(BUILD)/obj/pam.o"
	rm -f "$(BUILD)/obj/passHandler.o"
	rm -f "$(BUILD)/obj/pcre.o"
	rm -f "$(BUILD)/obj/pipeline.o"
	rm -f "$(BUILD)/obj/queue.o"
	rm -f "$(BUILD)/obj/rangeFilter.o"
	rm -f "$(BUILD)/obj/removeFiles.o"
	rm -f "$(BUILD)/obj/route.o"
	rm -f "$(BUILD)/obj/rx.o"
	rm -f "$(BUILD)/obj/sendConnector.o"
	rm -f "$(BUILD)/obj/service.o"
	rm -f "$(BUILD)/obj/session.o"
	rm -f "$(BUILD)/obj/stage.o"
	rm -f "$(BUILD)/obj/trace.o"
	rm -f "$(BUILD)/obj/tx.o"
	rm -f "$(BUILD)/obj/uploadFilter.o"
	rm -f "$(BUILD)/obj/uri.o"
	rm -f "$(BUILD)/obj/user.o"
	rm -f "$(BUILD)/obj/var.o"
	rm -f "$(BUILD)/obj/webSockFilter.o"
	rm -f "$(BUILD)/bin/http-server"
	rm -f "$(BUILD)/bin/http"
	rm -f "$(BUILD)/bin"
	rm -f "$(BUILD)/bin/libhttp.a"
	rm -f "$(BUILD)/bin/libmpr.a"
	rm -f "$(BUILD)/bin/libpcre.a"
	rm -f "$(BUILD)/bin/libmpr-openssl.a"

clobber: clean
	rm -fr ./$(BUILD)

#
#   est.h
#
DEPS_1 += src/est/est.h

$(BUILD)/inc/est.h: $(DEPS_1)
	@echo '      [Copy] $(BUILD)/inc/est.h'
	mkdir -p "$(BUILD)/inc"
	cp src/est/est.h $(BUILD)/inc/est.h

#
#   me.h
#

$(BUILD)/inc/me.h: $(DEPS_2)

#
#   osdep.h
#
DEPS_3 += src/osdep/osdep.h
DEPS_3 += $(BUILD)/inc/me.h

$(BUILD)/inc/osdep.h: $(DEPS_3)
	@echo '      [Copy] $(BUILD)/inc/osdep.h'
	mkdir -p "$(BUILD)/inc"
	cp src/osdep/osdep.h $(BUILD)/inc/osdep.h

#
#   mpr.h
#
DEPS_4 += src/mpr/mpr.h
DEPS_4 += $(BUILD)/inc/me.h
DEPS_4 += $(BUILD)/inc/osdep.h

$(BUILD)/inc/mpr.h: $(DEPS_4)
	@echo '      [Copy] $(BUILD)/inc/mpr.h'
	mkdir -p "$(BUILD)/inc"
	cp src/mpr/mpr.h $(BUILD)/inc/mpr.h

#
#   http.h
#
DEPS_5 += src/http.h
DEPS_5 += $(BUILD)/inc/mpr.h

$(BUILD)/inc/http.h: $(DEPS_5)
	@echo '      [Copy] $(BUILD)/inc/http.h'
	mkdir -p "$(BUILD)/inc"
	cp src/http.h $(BUILD)/inc/http.h

#
#   pcre.h
#
DEPS_6 += src/pcre/pcre.h

$(BUILD)/inc/pcre.h: $(DEPS_6)
	@echo '      [Copy] $(BUILD)/inc/pcre.h'
	mkdir -p "$(BUILD)/inc"
	cp src/pcre/pcre.h $(BUILD)/inc/pcre.h

#
#   http.h
#

src/http.h: $(DEPS_7)

#
#   actionHandler.o
#
DEPS_8 += src/http.h

$(BUILD)/obj/actionHandler.o: \
    src/actionHandler.c $(DEPS_8)
	@echo '   [Compile] $(BUILD)/obj/actionHandler.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/actionHandler.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/actionHandler.c

#
#   auth.o
#
DEPS_9 += src/http.h

$(BUILD)/obj/auth.o: \
    src/auth.c $(DEPS_9)
	@echo '   [Compile] $(BUILD)/obj/auth.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/auth.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/auth.c

#
#   basic.o
#
DEPS_10 += src/http.h

$(BUILD)/obj/basic.o: \
    src/basic.c $(DEPS_10)
	@echo '   [Compile] $(BUILD)/obj/basic.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/basic.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/basic.c

#
#   cache.o
#
DEPS_11 += src/http.h

$(BUILD)/obj/cache.o: \
    src/cache.c $(DEPS_11)
	@echo '   [Compile] $(BUILD)/obj/cache.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/cache.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/cache.c

#
#   chunkFilter.o
#
DEPS_12 += src/http.h

$(BUILD)/obj/chunkFilter.o: \
    src/chunkFilter.c $(DEPS_12)
	@echo '   [Compile] $(BUILD)/obj/chunkFilter.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/chunkFilter.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/chunkFilter.c

#
#   client.o
#
DEPS_13 += src/http.h

$(BUILD)/obj/client.o: \
    src/client.c $(DEPS_13)
	@echo '   [Compile] $(BUILD)/obj/client.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/client.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/client.c

#
#   config.o
#
DEPS_14 += src/http.h

$(BUILD)/obj/config.o: \
    src/config.c $(DEPS_14)
	@echo '   [Compile] $(BUILD)/obj/config.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/config.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/config.c

#
#   conn.o
#
DEPS_15 += src/http.h

$(BUILD)/obj/conn.o: \
    src/conn.c $(DEPS_15)
	@echo '   [Compile] $(BUILD)/obj/conn.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/conn.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/conn.c

#
#   digest.o
#
DEPS_16 += src/http.h

$(BUILD)/obj/digest.o: \
    src/digest.c $(DEPS_16)
	@echo '   [Compile] $(BUILD)/obj/digest.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/digest.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/digest.c

#
#   dirHandler.o
#
DEPS_17 += src/http.h

$(BUILD)/obj/dirHandler.o: \
    src/dirHandler.c $(DEPS_17)
	@echo '   [Compile] $(BUILD)/obj/dirHandler.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/dirHandler.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/dirHandler.c

#
#   endpoint.o
#
DEPS_18 += src/http.h
DEPS_18 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/endpoint.o: \
    src/endpoint.c $(DEPS_18)
	@echo '   [Compile] $(BUILD)/obj/endpoint.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/endpoint.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/endpoint.c

#
#   error.o
#
DEPS_19 += src/http.h

$(BUILD)/obj/error.o: \
    src/error.c $(DEPS_19)
	@echo '   [Compile] $(BUILD)/obj/error.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/error.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/error.c

#
#   est.o
#
DEPS_20 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/est.o: \
    src/mpr-est/est.c $(DEPS_20)
	@echo '   [Compile] $(BUILD)/obj/est.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/est.o $(LDFLAGS) $(IFLAGS) src/mpr-est/est.c

#
#   est.h
#

src/est/est.h: $(DEPS_21)

#
#   estLib.o
#
DEPS_22 += src/est/est.h

$(BUILD)/obj/estLib.o: \
    src/est/estLib.c $(DEPS_22)
	@echo '   [Compile] $(BUILD)/obj/estLib.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/estLib.o $(LDFLAGS) $(IFLAGS) src/est/estLib.c

#
#   fileHandler.o
#
DEPS_23 += src/http.h

$(BUILD)/obj/fileHandler.o: \
    src/fileHandler.c $(DEPS_23)
	@echo '   [Compile] $(BUILD)/obj/fileHandler.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/fileHandler.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/fileHandler.c

#
#   host.o
#
DEPS_24 += src/http.h
DEPS_24 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/host.o: \
    src/host.c $(DEPS_24)
	@echo '   [Compile] $(BUILD)/obj/host.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/host.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/host.c

#
#   http-server.o
#
DEPS_25 += $(BUILD)/inc/http.h

$(BUILD)/obj/http-server.o: \
    test/http-server.c $(DEPS_25)
	@echo '   [Compile] $(BUILD)/obj/http-server.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/http-server.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" test/http-server.c

#
#   http.o
#
DEPS_26 += src/http.h

$(BUILD)/obj/http.o: \
    src/http.c $(DEPS_26)
	@echo '   [Compile] $(BUILD)/obj/http.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/http.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/http.c

#
#   monitor.o
#
DEPS_27 += src/http.h

$(BUILD)/obj/monitor.o: \
    src/monitor.c $(DEPS_27)
	@echo '   [Compile] $(BUILD)/obj/monitor.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/monitor.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/monitor.c

#
#   mpr.h
#

src/mpr/mpr.h: $(DEPS_28)

#
#   mprLib.o
#
DEPS_29 += src/mpr/mpr.h

$(BUILD)/obj/mprLib.o: \
    src/mpr/mprLib.c $(DEPS_29)
	@echo '   [Compile] $(BUILD)/obj/mprLib.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/mprLib.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/mpr/mprLib.c

#
#   netConnector.o
#
DEPS_30 += src/http.h

$(BUILD)/obj/netConnector.o: \
    src/netConnector.c $(DEPS_30)
	@echo '   [Compile] $(BUILD)/obj/netConnector.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/netConnector.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/netConnector.c

#
#   openssl.o
#
DEPS_31 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/openssl.o: \
    src/mpr-openssl/openssl.c $(DEPS_31)
	@echo '   [Compile] $(BUILD)/obj/openssl.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/openssl.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/mpr-openssl/openssl.c

#
#   packet.o
#
DEPS_32 += src/http.h

$(BUILD)/obj/packet.o: \
    src/packet.c $(DEPS_32)
	@echo '   [Compile] $(BUILD)/obj/packet.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/packet.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/packet.c

#
#   pam.o
#
DEPS_33 += src/http.h

$(BUILD)/obj/pam.o: \
    src/pam.c $(DEPS_33)
	@echo '   [Compile] $(BUILD)/obj/pam.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/pam.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/pam.c

#
#   passHandler.o
#
DEPS_34 += src/http.h

$(BUILD)/obj/passHandler.o: \
    src/passHandler.c $(DEPS_34)
	@echo '   [Compile] $(BUILD)/obj/passHandler.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/passHandler.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/passHandler.c

#
#   pcre.h
#

src/pcre/pcre.h: $(DEPS_35)

#
#   pcre.o
#
DEPS_36 += $(BUILD)/inc/me.h
DEPS_36 += src/pcre/pcre.h

$(BUILD)/obj/pcre.o: \
    src/pcre/pcre.c $(DEPS_36)
	@echo '   [Compile] $(BUILD)/obj/pcre.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/pcre.o $(LDFLAGS) $(IFLAGS) src/pcre/pcre.c

#
#   pipeline.o
#
DEPS_37 += src/http.h

$(BUILD)/obj/pipeline.o: \
    src/pipeline.c $(DEPS_37)
	@echo '   [Compile] $(BUILD)/obj/pipeline.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/pipeline.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/pipeline.c

#
#   queue.o
#
DEPS_38 += src/http.h

$(BUILD)/obj/queue.o: \
    src/queue.c $(DEPS_38)
	@echo '   [Compile] $(BUILD)/obj/queue.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/queue.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/queue.c

#
#   rangeFilter.o
#
DEPS_39 += src/http.h

$(BUILD)/obj/rangeFilter.o: \
    src/rangeFilter.c $(DEPS_39)
	@echo '   [Compile] $(BUILD)/obj/rangeFilter.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/rangeFilter.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/rangeFilter.c

#
#   removeFiles.o
#

$(BUILD)/obj/removeFiles.o: \
    package/windows/removeFiles.c $(DEPS_40)
	@echo '   [Compile] $(BUILD)/obj/removeFiles.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/removeFiles.o $(LDFLAGS) $(IFLAGS) package/windows/removeFiles.c

#
#   route.o
#
DEPS_41 += src/http.h
DEPS_41 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/route.o: \
    src/route.c $(DEPS_41)
	@echo '   [Compile] $(BUILD)/obj/route.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/route.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/route.c

#
#   rx.o
#
DEPS_42 += src/http.h

$(BUILD)/obj/rx.o: \
    src/rx.c $(DEPS_42)
	@echo '   [Compile] $(BUILD)/obj/rx.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/rx.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/rx.c

#
#   sendConnector.o
#
DEPS_43 += src/http.h

$(BUILD)/obj/sendConnector.o: \
    src/sendConnector.c $(DEPS_43)
	@echo '   [Compile] $(BUILD)/obj/sendConnector.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/sendConnector.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/sendConnector.c

#
#   service.o
#
DEPS_44 += src/http.h

$(BUILD)/obj/service.o: \
    src/service.c $(DEPS_44)
	@echo '   [Compile] $(BUILD)/obj/service.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/service.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/service.c

#
#   session.o
#
DEPS_45 += src/http.h

$(BUILD)/obj/session.o: \
    src/session.c $(DEPS_45)
	@echo '   [Compile] $(BUILD)/obj/session.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/session.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/session.c

#
#   stage.o
#
DEPS_46 += src/http.h

$(BUILD)/obj/stage.o: \
    src/stage.c $(DEPS_46)
	@echo '   [Compile] $(BUILD)/obj/stage.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/stage.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/stage.c

#
#   trace.o
#
DEPS_47 += src/http.h

$(BUILD)/obj/trace.o: \
    src/trace.c $(DEPS_47)
	@echo '   [Compile] $(BUILD)/obj/trace.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/trace.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/trace.c

#
#   tx.o
#
DEPS_48 += src/http.h

$(BUILD)/obj/tx.o: \
    src/tx.c $(DEPS_48)
	@echo '   [Compile] $(BUILD)/obj/tx.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/tx.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/tx.c

#
#   uploadFilter.o
#
DEPS_49 += src/http.h

$(BUILD)/obj/uploadFilter.o: \
    src/uploadFilter.c $(DEPS_49)
	@echo '   [Compile] $(BUILD)/obj/uploadFilter.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/uploadFilter.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/uploadFilter.c

#
#   uri.o
#
DEPS_50 += src/http.h

$(BUILD)/obj/uri.o: \
    src/uri.c $(DEPS_50)
	@echo '   [Compile] $(BUILD)/obj/uri.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/uri.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/uri.c

#
#   user.o
#
DEPS_51 += src/http.h

$(BUILD)/obj/user.o: \
    src/user.c $(DEPS_51)
	@echo '   [Compile] $(BUILD)/obj/user.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/user.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/user.c

#
#   var.o
#
DEPS_52 += src/http.h

$(BUILD)/obj/var.o: \
    src/var.c $(DEPS_52)
	@echo '   [Compile] $(BUILD)/obj/var.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/var.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/var.c

#
#   webSockFilter.o
#
DEPS_53 += src/http.h

$(BUILD)/obj/webSockFilter.o: \
    src/webSockFilter.c $(DEPS_53)
	@echo '   [Compile] $(BUILD)/obj/webSockFilter.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/webSockFilter.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/webSockFilter.c

ifeq ($(ME_COM_EST),1)
#
#   libest
#
DEPS_54 += $(BUILD)/inc/osdep.h
DEPS_54 += $(BUILD)/inc/est.h
DEPS_54 += $(BUILD)/obj/estLib.o

$(BUILD)/bin/libest.a: $(DEPS_54)
	@echo '      [Link] $(BUILD)/bin/libest.a'
	ar -cr $(BUILD)/bin/libest.a "$(BUILD)/obj/estLib.o"
endif

ifeq ($(ME_COM_SSL),1)
#
#   est
#
ifeq ($(ME_COM_EST),1)
    DEPS_55 += $(BUILD)/bin/libest.a
endif
DEPS_55 += $(BUILD)/obj/est.o

$(BUILD)/bin/libmpr-estssl.a: $(DEPS_55)
	@echo '      [Link] $(BUILD)/bin/libmpr-estssl.a'
	ar -cr $(BUILD)/bin/libmpr-estssl.a "$(BUILD)/obj/est.o"
endif

ifeq ($(ME_COM_SSL),1)
#
#   openssl
#
DEPS_56 += $(BUILD)/obj/openssl.o

$(BUILD)/bin/libmpr-openssl.a: $(DEPS_56)
	@echo '      [Link] $(BUILD)/bin/libmpr-openssl.a'
	ar -cr $(BUILD)/bin/libmpr-openssl.a "$(BUILD)/obj/openssl.o"
endif

#
#   libmpr
#
DEPS_57 += $(BUILD)/inc/osdep.h
ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_OPENSSL),1)
    DEPS_57 += $(BUILD)/bin/libmpr-openssl.a
endif
endif
ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_EST),1)
    DEPS_57 += $(BUILD)/bin/libmpr-estssl.a
endif
endif
DEPS_57 += $(BUILD)/inc/mpr.h
DEPS_57 += $(BUILD)/obj/mprLib.o

$(BUILD)/bin/libmpr.a: $(DEPS_57)
	@echo '      [Link] $(BUILD)/bin/libmpr.a'
	ar -cr $(BUILD)/bin/libmpr.a "$(BUILD)/obj/mprLib.o"

ifeq ($(ME_COM_PCRE),1)
#
#   libpcre
#
DEPS_58 += $(BUILD)/inc/pcre.h
DEPS_58 += $(BUILD)/obj/pcre.o

$(BUILD)/bin/libpcre.a: $(DEPS_58)
	@echo '      [Link] $(BUILD)/bin/libpcre.a'
	ar -cr $(BUILD)/bin/libpcre.a "$(BUILD)/obj/pcre.o"
endif

#
#   libhttp
#
DEPS_59 += $(BUILD)/bin/libmpr.a
ifeq ($(ME_COM_PCRE),1)
    DEPS_59 += $(BUILD)/bin/libpcre.a
endif
DEPS_59 += $(BUILD)/inc/http.h
DEPS_59 += $(BUILD)/obj/actionHandler.o
DEPS_59 += $(BUILD)/obj/auth.o
DEPS_59 += $(BUILD)/obj/basic.o
DEPS_59 += $(BUILD)/obj/cache.o
DEPS_59 += $(BUILD)/obj/chunkFilter.o
DEPS_59 += $(BUILD)/obj/client.o
DEPS_59 += $(BUILD)/obj/config.o
DEPS_59 += $(BUILD)/obj/conn.o
DEPS_59 += $(BUILD)/obj/digest.o
DEPS_59 += $(BUILD)/obj/dirHandler.o
DEPS_59 += $(BUILD)/obj/endpoint.o
DEPS_59 += $(BUILD)/obj/error.o
DEPS_59 += $(BUILD)/obj/fileHandler.o
DEPS_59 += $(BUILD)/obj/host.o
DEPS_59 += $(BUILD)/obj/monitor.o
DEPS_59 += $(BUILD)/obj/netConnector.o
DEPS_59 += $(BUILD)/obj/packet.o
DEPS_59 += $(BUILD)/obj/pam.o
DEPS_59 += $(BUILD)/obj/passHandler.o
DEPS_59 += $(BUILD)/obj/pipeline.o
DEPS_59 += $(BUILD)/obj/queue.o
DEPS_59 += $(BUILD)/obj/rangeFilter.o
DEPS_59 += $(BUILD)/obj/route.o
DEPS_59 += $(BUILD)/obj/rx.o
DEPS_59 += $(BUILD)/obj/sendConnector.o
DEPS_59 += $(BUILD)/obj/service.o
DEPS_59 += $(BUILD)/obj/session.o
DEPS_59 += $(BUILD)/obj/stage.o
DEPS_59 += $(BUILD)/obj/trace.o
DEPS_59 += $(BUILD)/obj/tx.o
DEPS_59 += $(BUILD)/obj/uploadFilter.o
DEPS_59 += $(BUILD)/obj/uri.o
DEPS_59 += $(BUILD)/obj/user.o
DEPS_59 += $(BUILD)/obj/var.o
DEPS_59 += $(BUILD)/obj/webSockFilter.o

$(BUILD)/bin/libhttp.a: $(DEPS_59)
	@echo '      [Link] $(BUILD)/bin/libhttp.a'
	ar -cr $(BUILD)/bin/libhttp.a "$(BUILD)/obj/actionHandler.o" "$(BUILD)/obj/auth.o" "$(BUILD)/obj/basic.o" "$(BUILD)/obj/cache.o" "$(BUILD)/obj/chunkFilter.o" "$(BUILD)/obj/client.o" "$(BUILD)/obj/config.o" "$(BUILD)/obj/conn.o" "$(BUILD)/obj/digest.o" "$(BUILD)/obj/dirHandler.o" "$(BUILD)/obj/endpoint.o" "$(BUILD)/obj/error.o" "$(BUILD)/obj/fileHandler.o" "$(BUILD)/obj/host.o" "$(BUILD)/obj/monitor.o" "$(BUILD)/obj/netConnector.o" "$(BUILD)/obj/packet.o" "$(BUILD)/obj/pam.o" "$(BUILD)/obj/passHandler.o" "$(BUILD)/obj/pipeline.o" "$(BUILD)/obj/queue.o" "$(BUILD)/obj/rangeFilter.o" "$(BUILD)/obj/route.o" "$(BUILD)/obj/rx.o" "$(BUILD)/obj/sendConnector.o" "$(BUILD)/obj/service.o" "$(BUILD)/obj/session.o" "$(BUILD)/obj/stage.o" "$(BUILD)/obj/trace.o" "$(BUILD)/obj/tx.o" "$(BUILD)/obj/uploadFilter.o" "$(BUILD)/obj/uri.o" "$(BUILD)/obj/user.o" "$(BUILD)/obj/var.o" "$(BUILD)/obj/webSockFilter.o"

#
#   http-server
#
DEPS_60 += $(BUILD)/bin/libhttp.a
DEPS_60 += $(BUILD)/obj/http-server.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_60 += -lmpr-openssl
    LIBPATHS_60 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_60 += -lssl
    LIBPATHS_60 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_60 += -lcrypto
    LIBPATHS_60 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_60 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_60 += -lmpr-estssl
endif
LIBS_60 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_60 += -lmpr-openssl
    LIBPATHS_60 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_60 += -lpcre
endif
LIBS_60 += -lhttp
ifeq ($(ME_COM_PCRE),1)
    LIBS_60 += -lpcre
endif
LIBS_60 += -lmpr

$(BUILD)/bin/http-server: $(DEPS_60)
	@echo '      [Link] $(BUILD)/bin/http-server'
	$(CC) -o $(BUILD)/bin/http-server $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/http-server.o" $(LIBPATHS_60) $(LIBS_60) $(LIBS_60) $(LIBS) $(LIBS) 

#
#   httpcmd
#
DEPS_61 += $(BUILD)/bin/libhttp.a
DEPS_61 += $(BUILD)/obj/http.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_61 += -lmpr-openssl
    LIBPATHS_61 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_61 += -lssl
    LIBPATHS_61 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_61 += -lcrypto
    LIBPATHS_61 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_61 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_61 += -lmpr-estssl
endif
LIBS_61 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_61 += -lmpr-openssl
    LIBPATHS_61 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_61 += -lpcre
endif
LIBS_61 += -lhttp
ifeq ($(ME_COM_PCRE),1)
    LIBS_61 += -lpcre
endif
LIBS_61 += -lmpr

$(BUILD)/bin/http: $(DEPS_61)
	@echo '      [Link] $(BUILD)/bin/http'
	$(CC) -o $(BUILD)/bin/http $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/http.o" $(LIBPATHS_61) $(LIBS_61) $(LIBS_61) $(LIBS) $(LIBS) 

#
#   import-certs
#

import-certs: $(DEPS_62)

ifeq ($(ME_COM_SSL),1)
#
#   install-certs
#
DEPS_63 += src/certs/samples/ca.crt
DEPS_63 += src/certs/samples/ca.key
DEPS_63 += src/certs/samples/dh.pem
DEPS_63 += src/certs/samples/ec.crt
DEPS_63 += src/certs/samples/ec.key
DEPS_63 += src/certs/samples/roots.crt
DEPS_63 += src/certs/samples/self.crt
DEPS_63 += src/certs/samples/self.key
DEPS_63 += src/certs/samples/test.crt
DEPS_63 += src/certs/samples/test.key

$(BUILD)/bin: $(DEPS_63)
	@echo '      [Copy] $(BUILD)/bin'
	mkdir -p "$(BUILD)/bin"
	cp src/certs/samples/ca.crt $(BUILD)/bin/ca.crt
	cp src/certs/samples/ca.key $(BUILD)/bin/ca.key
	cp src/certs/samples/dh.pem $(BUILD)/bin/dh.pem
	cp src/certs/samples/ec.crt $(BUILD)/bin/ec.crt
	cp src/certs/samples/ec.key $(BUILD)/bin/ec.key
	cp src/certs/samples/roots.crt $(BUILD)/bin/roots.crt
	cp src/certs/samples/self.crt $(BUILD)/bin/self.crt
	cp src/certs/samples/self.key $(BUILD)/bin/self.key
	cp src/certs/samples/test.crt $(BUILD)/bin/test.crt
	cp src/certs/samples/test.key $(BUILD)/bin/test.key
endif

#
#   installPrep
#

installPrep: $(DEPS_64)
	if [ "`id -u`" != 0 ] ; \
	then echo "Must run as root. Rerun with "sudo"" ; \
	exit 255 ; \
	fi

#
#   stop
#

stop: $(DEPS_65)

#
#   installBinary
#

installBinary: $(DEPS_66)

#
#   start
#

start: $(DEPS_67)

#
#   install
#
DEPS_68 += installPrep
DEPS_68 += stop
DEPS_68 += installBinary
DEPS_68 += start

install: $(DEPS_68)

#
#   uninstall
#
DEPS_69 += stop

uninstall: $(DEPS_69)

#
#   version
#

version: $(DEPS_70)
	echo $(VERSION)

