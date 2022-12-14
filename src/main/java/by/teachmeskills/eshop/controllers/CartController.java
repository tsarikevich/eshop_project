package by.teachmeskills.eshop.controllers;

import by.teachmeskills.eshop.entities.Cart;
import by.teachmeskills.eshop.services.CartService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import static by.teachmeskills.eshop.utils.EshopConstants.PRODUCT_ID;
import static by.teachmeskills.eshop.utils.EshopConstants.SHOPPING_CART;

@RestController
@SessionAttributes(SHOPPING_CART)
@RequestMapping("/cart")
public class CartController {
    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @GetMapping
    public ModelAndView openCartPage(@ModelAttribute(SHOPPING_CART) Cart cart) {
        return cartService.getCartData(cart);
    }

    @GetMapping("/add")
    public ModelAndView addProductToCart(@RequestParam(PRODUCT_ID) int id, @ModelAttribute(SHOPPING_CART) Cart cart) {
        return cartService.addProductToCartOnProductPage(id, cart);
    }

    @GetMapping("/decrease")
    public ModelAndView decreaseQuantityProductInCart(@RequestParam(PRODUCT_ID) int id, @ModelAttribute(SHOPPING_CART) Cart cart) {
        return cartService.decreaseQuantityProductInCart(id, cart);
    }

    @GetMapping("/delete")
    public ModelAndView deleteProductFromCart(@RequestParam(PRODUCT_ID) int id, @ModelAttribute(SHOPPING_CART) Cart cart) {
        return cartService.deleteProductFromCart(id, cart);
    }

    @GetMapping("/checkout")
    public ModelAndView checkout(@ModelAttribute(SHOPPING_CART) Cart cart) {
        return cartService.checkout(cart);
    }


    @ModelAttribute(SHOPPING_CART)
    public Cart shoppingCart() {
        return new Cart();
    }
}
