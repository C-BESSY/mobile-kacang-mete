class DateEdge {
  final int theStart;
  final int theEnd;

  const DateEdge({required this.theStart, required this.theEnd});

  factory DateEdge.forDaily(Map<String, dynamic> data) {
    return DateEdge(
      theStart: int.parse(data['tgl_awal']),
      theEnd: int.parse(data['tgl_akhir']),
    );
  }

  factory DateEdge.forMonthly(Map<String, dynamic> data) {
    return DateEdge(
      theStart: int.parse(data['bln_awal']),
      theEnd: int.parse(data['bln_akhir']),
    );
  }

  factory DateEdge.forYearly(Map<String, dynamic> data) {
    return DateEdge(
      theStart: int.parse(data['thn_awal']),
      theEnd: int.parse(data['thn_akhir']),
    );
  }
}
