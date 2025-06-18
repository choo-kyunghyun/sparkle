fullscreen_shortcut();
watermark();
FSM.update();
Level.update();
UserInterface.update();
Vertex.inspector_update();
Timer.update();
if (!RELEASE_MODE && Input.check("debug")) {
    debug_overlay_toggle();
}
