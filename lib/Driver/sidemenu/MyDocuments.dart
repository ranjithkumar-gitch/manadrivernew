import 'package:flutter/material.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  String? licenceFrontUrl;
  String? licenceBackUrl;

  @override
  void initState() {
    super.initState();
    _loadDocs();
  }

  Future<void> _loadDocs() async {
    licenceFrontUrl = await SharedPrefServices.getlicenceFront() ?? '';
    licenceBackUrl = await SharedPrefServices.getlicenceBack() ?? '';
    setState(() {});
  }

  void _openLicenceFolder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => LicenceDetailPage(
              frontUrl: licenceFrontUrl,
              backUrl: licenceBackUrl,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    "images/chevronLeft.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: "Documents",
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.folder,
                    color: Colors.orange,
                    size: 32,
                  ),
                  title: const Text("Driving Licence"),
                  subtitle: Text(
                    (licenceFrontUrl?.isNotEmpty ?? false) ||
                            (licenceBackUrl?.isNotEmpty ?? false)
                        ? "Uploaded"
                        : "Not uploaded",
                    style: TextStyle(
                      color:
                          (licenceFrontUrl?.isNotEmpty ?? false)
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _openLicenceFolder,
                ),
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: korangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.upload, color: Colors.white),
                  label: const Text(
                    "Upload Document",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LicenceDetailPage extends StatelessWidget {
  final String? frontUrl;
  final String? backUrl;

  const LicenceDetailPage({super.key, this.frontUrl, this.backUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driving Licence"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:
                        frontUrl != null && frontUrl!.isNotEmpty
                            ? Image.network(frontUrl!, fit: BoxFit.contain)
                            : Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Text("No Front Image"),
                              ),
                            ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:
                        backUrl != null && backUrl!.isNotEmpty
                            ? Image.network(backUrl!, fit: BoxFit.contain)
                            : Container(
                              color: Colors.grey.shade200,
                              child: const Center(child: Text("No Back Image")),
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
