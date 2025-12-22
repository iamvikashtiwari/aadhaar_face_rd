String buildPidOptionsXml({
  required String txnId,
  String language = 'en',
  String pidVer = '2.0',
  String env = 'P',

  // OPTIONAL (for iOS headless mode)
  String? auaCode,
  String? callbackUrl,
  String? auaAuthToken,
}) {
  final buffer = StringBuffer();

  buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
  buffer.writeln('<PidOptions ver="1.0" env="$env">');

  buffer.writeln(
    '  <Opts format="0" pidVer="$pidVer" otp="" wadh="" />',
  );

  buffer.writeln('  <CustOpts>');
  buffer.writeln('    <Param name="txnId" value="$txnId" />');
  buffer.writeln('    <Param name="language" value="$language" />');

  // ✅ UIDAI iOS – OPTIONAL PARAMS (added only if present)

  if (auaCode != null && auaCode.isNotEmpty) {
    buffer.writeln(
      '    <Param name="auaCode" value="$auaCode" />',
    );
  }

  if (callbackUrl != null && callbackUrl.isNotEmpty) {
    buffer.writeln(
      '    <Param name="callBackUrl" value="$callbackUrl" />',
    );
  }

  if (auaAuthToken != null && auaAuthToken.isNotEmpty) {
    buffer.writeln(
      '    <Param name="auaAuthToken" value="$auaAuthToken" />',
    );
  }

  buffer.writeln('  </CustOpts>');
  buffer.writeln('</PidOptions>');

  return buffer.toString();
}
