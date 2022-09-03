package by.teachmeskills.eshop.services;

import by.teachmeskills.eshop.entities.Cart;
import by.teachmeskills.eshop.entities.Order;
import by.teachmeskills.eshop.entities.Product;
import by.teachmeskills.eshop.entities.User;
import by.teachmeskills.eshop.repositories.OrderRepository;
import by.teachmeskills.eshop.repositories.ProductRepository;
import by.teachmeskills.eshop.repositories.UserRepository;
import lombok.extern.log4j.Log4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDateTime;
import java.util.Optional;

import static by.teachmeskills.eshop.utils.EshopConstants.CART_PRODUCTS;
import static by.teachmeskills.eshop.utils.EshopConstants.LOGIN_AUTH_USER;
import static by.teachmeskills.eshop.utils.EshopConstants.REDIRECT_TO_CART_PAGE;
import static by.teachmeskills.eshop.utils.EshopConstants.REDIRECT_TO_HOME_PAGE;
import static by.teachmeskills.eshop.utils.EshopConstants.REDIRECT_TO_PROFILE_PAGE;
import static by.teachmeskills.eshop.utils.EshopConstants.TOTAL_COST;
import static by.teachmeskills.eshop.utils.PagesPathEnum.CART_PAGE;

@Service
@Log4j
public class CartService {
    private final UserService userService;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;
    private final OrderRepository orderRepository;

    public CartService(UserService userService, UserRepository userRepository, ProductRepository productRepository, OrderRepository orderRepository) {
        this.userService = userService;
        this.userRepository = userRepository;
        this.productRepository = productRepository;
        this.orderRepository = orderRepository;
    }

    private void addProductToCart(int productId, Cart cart) {
        Optional<Product> product = productRepository.findById(productId);
        product.ifPresent(cart::addProduct);
    }

    public ModelAndView addProductToCartOnProductPage(int productId, Cart cart) {
        addProductToCart(productId, cart);
        return new ModelAndView(REDIRECT_TO_CART_PAGE);
    }

    public ModelAndView decreaseQuantityProductInCart(int productId, Cart cart) {
        Optional<Product> product = productRepository.findById(productId);
        product.ifPresent(cart::deleteOneProduct);
        return new ModelAndView(REDIRECT_TO_CART_PAGE);
    }

    public ModelAndView deleteProductFromCart(int productId, Cart cart) {
        Optional<Product> product = productRepository.findById(productId);
        cart.deleteProducts(product.get());
        return new ModelAndView(REDIRECT_TO_CART_PAGE);
    }

    public ModelAndView getCartData(Cart cart) {
        ModelMap modelMap = new ModelMap();
        modelMap.addAttribute(CART_PRODUCTS, cart.getProducts());
        modelMap.addAttribute(TOTAL_COST, cart.getTotalPrice());
        modelMap.addAttribute(LOGIN_AUTH_USER, userService.getAuthorizationUserLoginOrDefault());
        return new ModelAndView(CART_PAGE.getPath(), modelMap);
    }

    public ModelAndView checkout(Cart cart) {
        try {
            User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            Order order = Order.builder()
                    .price(cart.getTotalPrice())
                    .date(LocalDateTime.now())
                    .user(userRepository.findById(user.getId()).get())
                    .products(cart.getProducts())
                    .build();
            orderRepository.save(order);
            cart.clear();
        } catch (Exception e) {
            log.error(e.getMessage());
            return new ModelAndView(REDIRECT_TO_HOME_PAGE);
        }
        return new ModelAndView(REDIRECT_TO_PROFILE_PAGE);
    }
}
