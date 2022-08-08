package by.teachmeskills.eshop.services;

import by.teachmeskills.eshop.entities.User;
import by.teachmeskills.eshop.repositories.UserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service("userDetailsService")
public class CustomUserDetailsService implements UserDetailsService {
    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String login) throws UsernameNotFoundException {
//        UserDetails userDetails;
        Optional<User> user = userRepository.findUserByLogin(login);
        if (user.isEmpty()) {

//            User user1=user.get();
//            Set<GrantedAuthority> roles = new HashSet<>();
//            Set<Role> userRoles=user.get().getRoles();
//            for (Role userRole : userRoles) {
//                roles.add(new SimpleGrantedAuthority(userRole.getRole()));
//            }
//
//            userDetails = new org.springframework.security.core.userdetails.User(user.get().getName(), user.get().getPassword(), roles);
//        } else {
            throw new UsernameNotFoundException("User wasn't found");
        }
        return user.get();
    }
}
