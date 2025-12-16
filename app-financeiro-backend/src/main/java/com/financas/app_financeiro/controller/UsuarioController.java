package com.financas.app_financeiro.controller;

import com.financas.app_financeiro.model.Usuario;
import com.financas.app_financeiro.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController // Define que essa classe é um Controller REST
@RequestMapping("/usuarios") // Define o endpoint como /usuarios
public class UsuarioController {

    @Autowired // Injeção de Dependência: O Spring traz o Repository pronto para usarmos
    private UsuarioRepository usuarioRepository;

    // 1. Rota para LISTAR todos os usuários (GET)
    @GetMapping
    public List<Usuario> listarUsuarios() {
        return usuarioRepository.findAll(); // SQL: Select * from usuarios
    }

    // 2. Rota para CRIAR um usuário novo (POST)
    @PostMapping
    public Usuario criarUsuario(@RequestBody Usuario usuario) {
        // @RequestBody diz: "Pegue o JSON que veio no pedido e transforme num Objeto Usuario"
        return usuarioRepository.save(usuario); // SQL: Insert into...
    }
    
    // 3. Rota para LOGIN (POST)
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String email = credentials.get("email");
        String senha = credentials.get("senha");
        
        Usuario usuario = usuarioRepository.findByEmailAndSenha(email, senha);
        
        if (usuario != null) {
            return ResponseEntity.ok(usuario);
        } else {
            return ResponseEntity.status(401).body(Map.of("erro", "Email ou senha incorretos"));
        }
    }
    
    // 4. Rota para REGISTRAR novo usuário (POST)
    @PostMapping("/registrar")
    public ResponseEntity<?> registrar(@RequestBody Usuario usuario) {
        // Verificar se o email já existe
        if (usuarioRepository.existsByEmail(usuario.getEmail())) {
            return ResponseEntity.status(400).body(Map.of("erro", "Email já cadastrado"));
        }
        
        // Salvar novo usuário
        Usuario novoUsuario = usuarioRepository.save(usuario);
        return ResponseEntity.ok(novoUsuario);
    }
}