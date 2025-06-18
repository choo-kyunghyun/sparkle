string_exp = "Amount of xp:";
for (var _i = 5; _i <= 100; _i += 5) {
    var _value = Animcurve.evaluate(ac_benchmark_exp, "curve1", _i / 100);
    string_exp += $"\nLv. {floor(_i)}: {floor(_value * 65536)} points";
}
