# This configuration is for NRF51 chips. The nordic libraries
# tend to assume some toolchain embedded .a files are present,
# and rather than having AS/LD find them they resort to having
# gcc due to linking. For that reason gcc is used for both tasks.
# Additionally, this file is being used to automatically handle the
# board support / common driver includes and linker script side of
# building for the platform.

TOOLCHAIN := $(TOOLCHAIN_PATH)/bin/arm-none-eabi-
AS		 := $(TOOLCHAIN)gcc
CC 		 := $(TOOLCHAIN)gcc
LD 		 := $(TOOLCHAIN)gcc
NM 		 := $(TOOLCHAIN)nm
SIZE 	 := $(TOOLCHAIN)size
OBJDUMP  := $(TOOLCHAIN)objdump
OBJCOPY  := $(TOOLCHAIN)objcopy
CFLAGS	 := -std=gnu99 -Wall -O3
CFLAGS 	 += -mcpu=cortex-m0 -mthumb -mfloat-abi=soft -mabi=aapcs
CFLAGS	 += -fdata-sections -ffunction-sections -fno-strict-aliasing
CFLAGS 	 += -fno-builtin --short-enums
CFLAGS   += -Wno-unused-parameter -Wunreachable-code
ASFLAGS  += -x assembler-with-cpp
DEFINES  += NRF51 \
			BSP_DEFINES_ONLY
INCLUDES += \
			third_party/nrf51_sdk/components/device \
			third_party/nrf51_sdk/components/softdevice/s110/headers \
			third_party/nrf51_sdk/components/toolchain \
			third_party/nrf51_sdk/components/toolchain/gcc \
			third_party/nrf51_sdk/components/libraries/util \
			third_party/nrf51_sdk/components/drivers_nrf/common \
			third_party/nrf51_sdk/examples/bsp \
			src/nrf_common \

SOURCES  += \
			third_party/nrf51_sdk/components/toolchain/system_nrf51.c \
			third_party/nrf51_sdk/components/toolchain/gcc/gcc_startup_nrf51.s \
			third_party/nrf51_sdk/components/drivers_nrf/common/nrf_drv_common.c \
			src/nrf_common/retarget.c \

LDFLAGS  := -mthumb -mabi=aapcs -mcpu=cortex-m0
LDFLAGS  += -Wl,--gc-sections --specs=nano.specs -lc -lnosys
LDPATH   := third_party/nrf51_sdk/components/toolchain/gcc
LDSCRIPT := third_party/nrf51_sdk/components/softdevice/s130/toolchain/armgcc/armgcc_s130_nrf51822_xxaa.ld

include make/module.mk
include make/compile.mk
ALL += $(OUTPUT) $(OUTPUT).size $(OUTPUT).sym $(OUTPUT).lst $(OUTPUT).bin $(OUTPUT).hex
# vim: set noexpandtab ts=4 sw=4 sts=4
