# 2025-04-20T12:07:23.782614400
import vitis

client = vitis.create_client()
client.set_workspace(path="audio_testing")

platform = client.get_component(name="audio_test")
status = platform.build()

comp = client.get_component(name="pwm_test")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

vitis.dispose()

