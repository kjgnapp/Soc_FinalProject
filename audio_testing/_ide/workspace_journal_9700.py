# 2025-04-20T12:29:57.553231600
import vitis

client = vitis.create_client()
client.set_workspace(path="audio_testing")

platform = client.get_component(name="audio_test")
status = platform.build()

comp = client.get_component(name="pwm_test")
comp.build()

status = platform.build()

comp.build()

vitis.dispose()

vitis.dispose()

