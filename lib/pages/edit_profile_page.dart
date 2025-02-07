import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nicknameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  final _birthdayController = TextEditingController();
  String _gender = '选择性别';
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F9E6),
      appBar: AppBar(
        backgroundColor: Color(0xFFB1DF0B),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('编辑资料'),
        actions: [
          TextButton(
            onPressed: () {
              // 保存编辑的信息
              Navigator.pop(context, {
                'nickname': _nicknameController.text,
                'bio': _bioController.text,
                'gender': _gender,
                'birthday': _birthdayController.text,
                'location': _locationController.text,
              });
            },
            child: Text('保存', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.person, size: 50, color: Colors.grey),
                ),
                TextButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      // 处理头像更新
                    }
                  },
                  child: Text('更换头像'),
                ),
              ],
            ),
          ),
          _buildDivider(),
          _buildSection('昵称', _nicknameController, '填写昵称'),
          _buildSection('简介', _bioController, '填写简介，让大家认识更好的你！', maxLines: 3),
          _buildDivider(),
          _buildSection('性别', null, _gender, onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('选择性别'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('男'),
                      onTap: () {
                        setState(() => _gender = '男');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('女'),
                      onTap: () {
                        setState(() => _gender = '女');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
          _buildSection('生日', _birthdayController, '选择生日', onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                _birthdayController.text =
                    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
              });
            }
          }),
          _buildSection('地区', _locationController, '选择地区', onTap: () {
            // 这里可以添加地区选择器
          }),
        ],
      ),
    );
  }

  Widget _buildSection(
      String title, TextEditingController? controller, String hint,
      {int maxLines = 1, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: controller == null
                  ? Text(
                      hint,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  : TextField(
                      controller: controller,
                      maxLines: maxLines,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.add_photo_alternate, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[800],
      height: 1,
      thickness: 1,
    );
  }
}
