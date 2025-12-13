package com.financas.app_financeiro.controller;

import com.financas.app_financeiro.model.Usuario;
import com.financas.app_financeiro.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
}