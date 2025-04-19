# 2025-02-24T02:22:08.827860200
import vitis

client = vitis.create_client()
client.set_workspace(path="pong_testing3")

platform = client.create_platform_component(name = "platform",hw_design = "$COMPONENT_LOCATION/../../project_2/design_1_wrapper_v3.xsa",os = "standalone",cpu = "microblaze_riscv_0",domain_name = "standalone_microblaze_riscv_0")

platform = client.get_component(name="platform")
status = platform.build()

comp = client.create_app_component(name="hello_world",platform = "$COMPONENT_LOCATION/../platform/export/platform/platform.xpfm",domain = "standalone_microblaze_riscv_0",template = "hello_world")

status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

status = platform.build()

comp.build()

vitis.dispose()

