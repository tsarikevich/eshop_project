package by.teachmeskills.eshop.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@EnableWebSecurity(debug = true)
@EnableGlobalMethodSecurity(securedEnabled = true)
@ComponentScan(basePackages = "by")
@Configuration
public class WebSecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf()
                .disable()
                .authorizeHttpRequests((auth) -> {
                    try {
                        auth
                                .antMatchers("/resources/**", "/")
                                .permitAll()
                                .antMatchers("/profile/**")
                                .authenticated()
                                .antMatchers("/cart/**")
                                .authenticated()
//                                .antMatchers("/users/**")
//                                .hasAuthority("ROLE_ADMIN")
                                .and()
                                .formLogin()
                                .loginPage("/login")
                                .usernameParameter("login")
                                .passwordParameter("password")
                                .defaultSuccessUrl("/home")
                                .failureUrl("/registration")
                                .permitAll()
                                .and()
                                .logout()
                                .invalidateHttpSession(true)
                                .clearAuthentication(true)
                                .permitAll();
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                });
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
