<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>Products</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="../../resources/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<ul class="TopNavMenu">
    <li><a href='/home'><i class="fa fa-fw fa-home"></i> Главная</a></li>
    <li style="float:right"><a href='/cart'><i class="fa fa-fw fa-shopping-cart"></i>
        Корзина</a></li>
    <li style="float:right"><a href='/profile'><i class="fa fa-fw fa-user"></i>
        Пользователь</a></li>
    <li style="float:right"><a href='/search'><i class="fa fa-fw fa-search"></i>
        Поиск</a></li>
</ul>
<h2 style="padding-top: 16px">${nameCategory}</h2><br>
<%--<div class="btn-group">--%>
<%--    <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="false"--%>
<%--            aria-expanded="false">--%>
<%--        Выбрать количество продуктов на странице--%>
<%--    </button>--%>
<select onchange="location=value">
    <option value="Количество товаров на странице"></option>
    <option value="${contextPath}/category/${nameCategory}/${categoryId}?pageNumber=0&pageSize=3">3</option>
    <option value="${contextPath}/category/${nameCategory}/${categoryId}?pageNumber=0&pageSize=3">3</option>
    <option value="${contextPath}/category/${nameCategory}/${categoryId}?pageNumber=0&pageSize=5">5</option>
    <option value="${contextPath}/category/${nameCategory}/${categoryId}?pageNumber=0&pageSize=10">10</option>
    <option value="${contextPath}/category/${nameCategory}/${categoryId}?pageNumber=0&pageSize=15">15</option>
</select>
<div class="container-fluid">
    <c:if test="${not empty products}">
        <c:forEach items="${products}" var="product">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-lg-1" style="background-color:white;">
                        <c:forEach items="${productsImages}" var="image">
                            <c:if test="${product.getId()==image.product.getId()}">
                                <a href="${contextPath}/product/${product.getId()}">
                                    <img src="${contextPath}/images/${image.getImagePath()}"
                                         alt="${image.getImagePath()}" class="responsive"></a>
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="col" style="background-color:white;">
                        <p><b class="font-italic">Модель:</b> ${product.getName()}</p>
                        <p><b class="font-italic">Описание:</b> ${product.getDescription()}</p>
                        <p><b class="font-italic">Цена:</b> ${product.getPrice()} руб.</p>
                    </div>
                </div>
            </div>
            <br>
        </c:forEach>
        <sec:authorize access="hasRole('ADMIN')">
            <form method="POST" enctype="multipart/form-data"
                  action="${contextPath}/category/upload?categoryId=${categoryId}&nameCategory=${nameCategory}&pageNumber=0&pageSize=${pageSize}">
                File to upload:
                <input type="file" value="Select" name="file"><br/>
                <button type="submit"><i class="fa fa-upload fa-lg">Upload CSV File</i></button>
            </form>
        </sec:authorize>
        <sec:authorize access="isAuthenticated()">
            <a style="text-decoration: none"
               href="${contextPath}/category/download?categoryId=${categoryId}">
                <button><i class="fa fa-download fa-lg" style="padding-right: 5px"></i>Download CSV File</button>
            </a>
        </sec:authorize>
        <nav aria-label>
            <ul class="pagination justify-content-center">
                <c:choose>
                    <c:when test="${not isFirstPage}">
                        <li class="page-item"><a class="page-link"
                                                 href="${contextPath}/category/${nameCategory}/${categoryId}?pageNumber=${pageNumber-1}&pageSize=${pageSize}">Предыдущая</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item disabled"><a class="page-link">Предыдущая</a>
                        </li>
                    </c:otherwise>
                </c:choose>
                <c:forEach begin="0" end="${totalPages-1}" var="i">
                    <c:choose>
                        <c:when test="${pageNumber eq i}">
                            <li class="page-item">
                                <a class="page-link active">${i+1}</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item">
                                <a class="page-link"
                                   href="${contextPath}/category/${nameCategory}/${categoryId}?pageNumber=${i}&pageSize=${pageSize}">${i+1}</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:choose>
                    <c:when test="${not isLastPage}">
                        <li class="page-item"><a class="page-link"
                                                 href="${contextPath}/category/${nameCategory}/${categoryId}?pageNumber=${pageNumber+1}&pageSize=${pageSize}">Следующая</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item disabled"><a class="page-link">Следующая</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </nav>
    </c:if>
</div>
</body>
</html>


