import 'package:businessbuddy/utils/exported_path.dart';

typedef LocationSelected = void Function(Map<String, dynamic> location);
typedef LocationSearch =
    Future<List<Map<String, dynamic>>> Function(String query);

class LocationSearchField extends StatefulWidget {
  final TextEditingController controller;
  final RxList results;
  final LocationSearch onSearch;
  final LocationSelected onSelected;
  final String label;
  final String hintText;

  const LocationSearchField({
    super.key,
    required this.controller,
    required this.results,
    required this.onSearch,
    required this.onSelected,
    this.label = 'Location',
    this.hintText = 'Enter your location...',
  });

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final RxBool _isSearching = false.obs;
  final _debouncer = Debouncer(milliseconds: 600);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        _buildSearchField(),
        Obx(
          () => _isSearching.value
              ? _buildLoading()
              : widget.results.isNotEmpty
              ? _buildResults()
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        widget.label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextFormField(
      controller: widget.controller,
      maxLines: 3,
      minLines: 1,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.controller.clear();
                  widget.results.clear();
                  _isSearching.value = false;
                  setState(() {});
                },
              )
            : const Icon(Icons.search, color: Colors.grey),
        border: borderStyle(),
        enabledBorder: borderStyle(),
        focusedBorder: borderStyle(),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please search your location' : null,
      onChanged: (value) {
        if (value.trim().isEmpty) {
          widget.results.clear();
          _isSearching.value = false;
          return;
        }

        _isSearching.value = true;

        _debouncer.run(() async {
          try {
            final data = await widget.onSearch(value.trim());
            widget.results.value = data;
          } catch (_) {
            widget.results.clear();
          } finally {
            _isSearching.value = false;
          }
        });
      },
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('Searching locations...'),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.results.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final item = widget.results[index];
          return ListTile(
            leading: const Icon(Icons.place_outlined),
            title: Text(item['description'] ?? ''),
            onTap: () {
              widget.onSelected(item);
              widget.results.clear();
              _isSearching.value = false;
            },
          );
        },
      ),
    );
  }
}
