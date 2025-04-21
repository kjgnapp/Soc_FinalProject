# 2025-04-21T15:24:33.472156900
import vitis

client = vitis.create_client()
client.set_workspace(path="audio_testing")

platform = client.get_component(name="platform_LEDTesting")
status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

vitis.dispose()

