package by.teachmeskills.eshop.services;

import by.teachmeskills.eshop.entities.Cart;
import by.teachmeskills.eshop.entities.Image;
import by.teachmeskills.eshop.entities.Order;
import by.teachmeskills.eshop.entities.Product;
import by.teachmeskills.eshop.entities.User;
import by.teachmeskills.eshop.repositories.ImageRepository;
import by.teachmeskills.eshop.repositories.OrderRepository;
import by.teachmeskills.eshop.repositories.ProductRepository;
import by.teachmeskills.eshop.utils.EshopConstants;
import by.teachmeskills.eshop.utils.PagesPathEnum;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDateTime;
import java.util.List;

import static by.teachmeskills.eshop.utils.RequestParamsEnum.ACTIVE_BUTTON_NAV_MENU;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.CART_PRODUCTS;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.CART_PRODUCTS_IMAGES;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.ONE_PRODUCT;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.ONE_PRODUCT_IMAGES;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.TOTAL_COST;

@Service
public class CartService {
    private final ProductRepository productRepository;
    private final ImageRepository imageRepository;
    private final OrderRepository orderRepository;

    public CartService(ProductRepository productRepository, ImageRepository imageRepository, OrderRepository orderRepository) {
        this.productRepository = productRepository;
        this.imageRepository = imageRepository;
        this.orderRepository = orderRepository;
    }

    public ModelAndView addProductToCart(int productId, Cart cart) {
        ModelMap modelMap = new ModelMap();
        Product product = productRepository.getProductById(productId);
        List<Image> productImages = imageRepository.getImagesByProductId(productId);
        cart.addProduct(product);
        modelMap.addAttribute(ONE_PRODUCT.getValue(), product);
        modelMap.addAttribute(ONE_PRODUCT_IMAGES.getValue(), productImages);
        return new ModelAndView(EshopConstants.REDIRECT_TO_PRODUCT_PAGE + "/" + productId, modelMap);
    }

    public ModelAndView deleteProductFromCart(int productId, Cart cart) {
        Product product = productRepository.getProductById(productId);
        cart.deleteProduct(product);
        return new ModelAndView(EshopConstants.REDIRECT_TO_CART_PAGE);
    }

    public ModelAndView getCartData(Cart cart) {
            ModelMap modelMap = new ModelMap();
            List<Image> cartProductsImages = imageRepository.getImagesByProductIn(cart.getListProducts());
            modelMap.addAttribute(CART_PRODUCTS.getValue(), cart.getProducts());
            modelMap.addAttribute(TOTAL_COST.getValue(), cart.getTotalPrice());
            modelMap.addAttribute(CART_PRODUCTS_IMAGES.getValue(), cartProductsImages);
            modelMap.addAttribute(ACTIVE_BUTTON_NAV_MENU.getValue(), true);
            return new ModelAndView(PagesPathEnum.CART_PAGE.getPath(), modelMap);
    }

    public ModelAndView checkout(Cart cart) {
        User user=(User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Order order = Order.builder()
                .price(cart.getTotalPrice())
                .date(LocalDateTime.now())
                .user(user)
                .products(cart.getProducts())
                .build();
        orderRepository.save(order);
        cart.clear();
        return new ModelAndView(EshopConstants.REDIRECT_TO_PROFILE_PAGE);
    }
}
