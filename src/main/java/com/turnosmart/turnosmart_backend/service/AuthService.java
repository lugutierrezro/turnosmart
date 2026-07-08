package com.turnosmart.turnosmart_backend.service;

import com.turnosmart.turnosmart_backend.entity.Role;
import com.turnosmart.turnosmart_backend.entity.User;
import com.turnosmart.turnosmart_backend.repository.RoleRepository;
import com.turnosmart.turnosmart_backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserService userService;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public void register(User user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("El correo electrónico ya se encuentra registrado.");
        }

        if (userRepository.existsByDni(user.getDni())) {
            throw new RuntimeException("El DNI ingresado ya se encuentra registrado.");
        }
        if (user.getPassword() == null || user.getPassword().trim().length() < 8) {
            throw new RuntimeException("La contraseña es muy corta. Debe contener un mínimo de 8 caracteres.");
        }

        Role defaultRole = roleRepository.findByName("ROLE_CLIENTE")
                .orElseThrow(() -> new RuntimeException("Error crítico: El rol ROLE_CLIENTE no existe en la base de datos."));

        user.setSingleRole(defaultRole);

        userService.register(user);
    }

    public boolean authenticate(String email, String password) {
        Optional<User> userOpt = userRepository.findByEmail(email);

        if (userOpt.isEmpty()) {
            return false; // Si el correo no existe, no hacemos nada más
        }

        User user = userOpt.get();

        // 1. CONTROL DE SEGURIDAD: Si ya superó los intentos, la cuenta está bloqueada
        int LOCKOUT_DURATION_MINUTES = 5;
        if (user.getAccountLocked() != null && user.getAccountLocked()) {
            if (user.getLockTime() != null) {
                LocalDateTime lockExpiration = user.getLockTime().plusMinutes(LOCKOUT_DURATION_MINUTES);
                if (LocalDateTime.now().isAfter(lockExpiration)) {
                    // El tiempo de bloqueo expiró, desbloqueamos la cuenta
                    user.setAccountLocked(false);
                    user.setFailedAttempts(0);
                    user.setLockTime(null);
                    userRepository.save(user);
                } else {
                    // Aún bloqueado, calculamos los segundos restantes
                    long remainingSeconds = java.time.Duration.between(LocalDateTime.now(), lockExpiration).getSeconds();
                    if (remainingSeconds < 0) remainingSeconds = 0;
                    long minutes = remainingSeconds / 60;
                    long seconds = remainingSeconds % 60;
                    String timeStr = String.format("%02d:%02d", minutes, seconds);
                    throw new RuntimeException("La cuenta se encuentra bloqueada por superar el límite de 3 intentos fallidos. Se desbloqueará en " + timeStr + " minutos. [COOLDOWN:" + remainingSeconds + "]");
                }
            } else {
                // Por si acaso lockTime fuera nulo, lo reseteamos o bloqueamos con la hora actual
                user.setLockTime(LocalDateTime.now());
                userRepository.save(user);
                throw new RuntimeException("La cuenta se encuentra bloqueada por superar el límite de 3 intentos fallidos. Se desbloqueará en 05:00 minutos. [COOLDOWN:300]");
            }
        }

        // 2. VERIFICACIÓN DE CREDENCIALES
        if (passwordEncoder.matches(password, user.getPassword())) {
            // Si la clave es correcta y tenía intentos acumulados, los limpiamos a 0
            if (user.getFailedAttempts() == null || user.getFailedAttempts() > 0) {
                user.setFailedAttempts(0);
                user.setLockTime(null);
                user.setAccountLocked(false);
                userRepository.save(user);
            }
            return true;
        } else {
            // Si la clave es incorrecta, sumamos un intento fallido
            int currentAttempts = (user.getFailedAttempts() != null) ? user.getFailedAttempts() : 0;
            currentAttempts++;
            user.setFailedAttempts(currentAttempts);

            // Si llega a 3 intentos incorrectos, bloqueamos la cuenta por completo
            if (currentAttempts >= 3) {
                user.setAccountLocked(true);
                user.setLockTime(LocalDateTime.now());
                userRepository.save(user);
                throw new RuntimeException("Contraseña incorrecta. La cuenta ha sido bloqueada tras 3 intentos fallidos. Se desbloqueará en 05:00 minutos. [COOLDOWN:300]");
            }

            userRepository.save(user);
            return false;
        }
    }
}