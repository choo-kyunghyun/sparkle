var _begin_timer = get_timer();
event_benchmark_grass(1000000, depth);
var _end_timer = get_timer();
show_message(string(i18n.get("LOC_BENCHMARK_GRASS_RESULT"), (_end_timer - _begin_timer) / 1000000));
