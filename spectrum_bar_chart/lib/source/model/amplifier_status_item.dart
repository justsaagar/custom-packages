enum DetectedStatusType {
  online,
  offline,
  pending,
}

DetectedStatusType? getDetectedStatusType(String? status) {
  switch (status) {
    case 'online':
      return DetectedStatusType.online;
    case 'offline':
      return DetectedStatusType.offline;
    case 'pending':
      return DetectedStatusType.pending;
    default:
      return DetectedStatusType.offline; // or handle the default case accordingly
  }
}
