import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class ConfiguracoesView extends StatelessWidget {
  final SettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações")),
      body: Obx(() => controller.carregando.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPerfilSection(),
                  SizedBox(height: 24),
                  _buildPreferenciasSection(),
                  SizedBox(height: 24),
                  _buildAlterarSenhaSection(),
                ],
              ),
            )),
    );
  }

  Widget _buildPerfilSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: controller.fotoPerfilUrl.value.isNotEmpty
                      ? NetworkImage(controller.fotoPerfilUrl.value)
                      : AssetImage('assets/images/default-avatar.png') as ImageProvider,
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: controller.atualizarFotoPerfil,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.nomeController,
              decoration: InputDecoration(
                labelText: "Nome de usuário",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: controller.atualizarNome,
              child: Text("Atualizar Nome"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenciasSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Preferências", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Salário por hora",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.salarioPorHora.value = double.tryParse(value) ?? 0.0;
              },
            ),
            SizedBox(height: 16),
            Obx(() => SwitchListTile(
                  title: Text("Exibir cagadas públicas"),
                  value: controller.exibirPublicas.value,
                  onChanged: (value) => controller.exibirPublicas.value = value,
                )),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => controller.salvarPreferencias(controller.salarioPorHora.value),
              child: Text("Salvar Preferências"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlterarSenhaSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Alterar Senha", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(
              controller: controller.senhaAtualController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha atual",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: controller.novaSenhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Nova senha",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: controller.confirmarSenhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirmar nova senha",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.alterarSenha,
              child: Text("Alterar Senha"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
