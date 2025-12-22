import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/facerd_service.dart';
import 'package:aadhaar_face_rd/aadhaar_face_rd.dart';


class FaceRdDemoPage extends StatefulWidget {
  const FaceRdDemoPage({super.key});

  @override
  State<FaceRdDemoPage> createState() => _FaceRdDemoPageState();
}

class _FaceRdDemoPageState extends State<FaceRdDemoPage>
    with WidgetsBindingObserver {

  final FaceRDService _service = FaceRDService();

  String? _response;
  String? _txnId; // store txnId for iOS resume handling

  @override
  void initState() {
    super.initState();

    // Observe app lifecycle (IMPORTANT for iOS)
    WidgetsBinding.instance.addObserver(this);

    _service.onResponse.listen((resp) {
      setState(() => _response = resp);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _service.dispose();
    super.dispose();
  }

  //  iOS: user manually returns from FaceRD
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_txnId != null) {
        // 🔑 User came back from FaceRD
        // 👉 Poll backend using txnId
        // Example:
        // fetchFaceAuthStatus(_txnId!);

        debugPrint('App resumed after FaceRD, txnId=$_txnId');
      }
    }
  }

  /// Build PID XML and launch FaceRD
  Future<void> _startCapture() async {
    final installed = await _service.isInstalled();

    if (!installed) {
      _showInstallDialog();
      return;
    }

    //  Generate txnId once and store it
    _txnId = const Uuid().v4();

    final xml = buildPidOptionsXml(
      txnId: _txnId!,
      language: 'en',

      // IMPORTANT FOR iOS (backend-driven flow)
      // auaCode: 'YOUR_AUA_CODE',
      // callbackUrl: 'https://your-backend.com/facerd/callback',
    );

    try {
      await _service.launch(xml);
    } on PlatformException catch (e) {
      _showError(e.message ?? 'Failed to launch FaceRD');
    } catch (e) {
      _showError('Unexpected error: $e');
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void _showInstallDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Aadhaar FaceRD Required'),
        content: const Text(
          'Aadhaar FaceRD app is not installed on this device.\n\nPlease install it to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openStore();
            },
            child: const Text('Install'),
          ),
        ],
      ),
    );
  }

  void _openStore() {
    const androidUrl =
        'https://play.google.com/store/apps/details?id=in.gov.uidai.facerd';
    const iosUrl =
        'https://apps.apple.com/in/app/aadhaarfacerd/id6479888451';

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final url = isIOS ? iosUrl : androidUrl;

    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FaceRD Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _startCapture,
              child: const Text('Launch FaceRD'),
            ),

            const SizedBox(height: 20),

            if (_response != null)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: _response!),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied')),
                    );
                  },
                ),
              ),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _response ?? 'Waiting for FaceRD response...',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
