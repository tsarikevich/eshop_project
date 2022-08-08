package by.teachmeskills.eshop.controllers;

import by.teachmeskills.eshop.dto.SearchParamsDto;
import by.teachmeskills.eshop.services.ProductService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import static by.teachmeskills.eshop.utils.EshopConstants.PAGE_NUMBER;
import static by.teachmeskills.eshop.utils.EshopConstants.PAGE_SIZE;

@RestController
@RequestMapping(value = "/search")
public class SearchController {
    private final ProductService productService;

    public SearchController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public ModelAndView getSearchPage() {
        return productService.showSearchProductPage();
    }

    @PostMapping
    public ModelAndView getPageWithProducts(@ModelAttribute SearchParamsDto searchParamsDto,
                                            @RequestParam(value = PAGE_NUMBER, defaultValue = "0") int pageNumber,
                                            @RequestParam(value = PAGE_SIZE, defaultValue = "3") int pageSize) {
        return productService.searchProducts(searchParamsDto, pageNumber, pageSize);
    }
}
