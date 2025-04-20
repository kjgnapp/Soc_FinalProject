# 2025-04-19T23:10:39.691951
import vitis

client = vitis.create_client()
client.set_workspace(path="audio_testing")

platform = client.create_platform_component(name = "audio_test",hw_design = "$COMPONENT_LOCATION/../../project_2/design_1_wrapper.xsa",os = "standalone",cpu = "microblaze_riscv_0",domain_name = "standalone_microblaze_riscv_0")

comp = client.create_app_component(name="pwm_test",platform = "$COMPONENT_LOCATION/../audio_test/export/audio_test/audio_test.xpfm",domain = "standalone_microblaze_riscv_0",template = "hello_world")

platform = client.get_component(name="audio_test")
status = platform.build()

status = platform.build()

comp = client.get_component(name="pwm_test")
comp.build()

vitis.dispose()

