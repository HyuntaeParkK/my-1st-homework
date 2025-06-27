

import 'dart:io';

class Product {
  String name;
  int price;
  Product(this.name, this.price);
}

class CartItem {
  Product product;
  int quantity;

  CartItem(this.product, this.quantity);

  int get subtotal => product.price * quantity;
}

class ShoppingMall {
  List<Product> products = [
    Product('셔츠', 45000),
    Product('원피스', 30000),
    Product('반팔티', 35000),
    Product('반바지', 38000),
    Product('양말', 5000),
  ];
  List<CartItem> cart = [];

  void displayProduct() {
    print('\n--- 상품 목록 ---');
    for (int i = 0; i < products.length; i++) {
      print('${products[i].name} / ${products[i].price}원');
    }
    print('-----------------');
  }

  Product? getProductByName(String productName) {
    for (var product in products) {
      if (product.name == productName) {
        return product;
      }
    }
    return null; // 상품을 찾지 못하면 null 반환
  }

  void addProductToCart() {
    // 1. 사용자로부터 상품 이름 입력 받기
    stdout.write('장바구니에 담을 상품 이름을 입력하세요: ');
    String? productNameInput = stdin.readLineSync();
    String productName = productNameInput?.trim() ?? '';

    // 2. 입력된 상품 이름으로 Product 객체 찾기 및 유효성 검사
    Product? selectedProduct = getProductByName(productName);
    if (selectedProduct == null) {
      print('입력값이 올바르지 않아요 !//저희가 판매하지 않는 제품이에요. 초기 화면으로 돌아갑니다.');
      return; // 함수 종료
    }

    // 3. 상품 개수 입력 받기
    stdout.write('몇 개를 담으시겠어요?: '); // print를 쓰면 행바꿈이 되어서 대체
    String? quantityInput = stdin.readLineSync();
    int? quantity = int.tryParse(quantityInput?.trim() ?? '');

    // 4. 입력된 개수 유효성 검사
    if (quantity == null) {
      print('입력값이 올바르지 않아요 !');
      return; // 함수 종료
    }
    if (quantity <= 0) {
      print('0개보다 많은 개수의 상품만 담을 수 있어요 !');
      return; // 함수 종료
    }

    // --- 핵심 로직: 장바구니에 CartItem 추가 또는 업데이트 ---
    bool found = false;
    for (var item in cart) {
      if (item.product.name == selectedProduct.name) {
        item.quantity += quantity;
        found = true;
        break;
      }
    }

    if (!found) {
      cart.add(CartItem(selectedProduct, quantity));
    }
    print('장바구니에 ${selectedProduct.name} ${quantity}개 담겼어요 !');
  }

  void displayCartTotalPrice() {
    if (cart.isEmpty) {
      print('장바구니가 비어 있습니다.');
      return;
    }
    print('\n--- 장바구니 총 가격 ---');
    int totalPrice = 0;
    for (var item in cart) {
      totalPrice += item.subtotal;
      print('- ${item.product.name} (${item.quantity}개) : ${item.subtotal}원');
    }
    print('총 가격: ${totalPrice}원');
    print('-------------------------');
  }
}

void main() {
  ShoppingMall myMall = ShoppingMall();

  print('-------------------------------------------------------------------------------------');
  print('[1] 상품 목록보기 / [2] 장바구니에 담기 / [3] 장바구니에 담긴 상품의 총 가격 보기 / [4] 프로그램 종료');
  print('-------------------------------------------------------------------------------------');

  while (true) {
    stdout.write('메뉴를 선택하세요 (1-4): '); // 사용자에게 입력 안내 메시지 추가
    String? input = stdin.readLineSync();
    String command = input?.trim() ?? '';

    if (command == '1') {
      myMall.displayProduct();
    }
    else if (command == '2') {
      myMall.addProductToCart(); // addProductToCart 메서드가 모든 것을 처리
    } else if (command == '3') {
      myMall.displayCartTotalPrice();
    }
    // --- 개선 5: 종료 로직 및 기본 메시지 개선 ---
    else if (command == '4') {
      stdout.write('정말 종료하시겠습니까? (Y/N): ');
      String? confirmInput = stdin.readLineSync();
      String confirm = confirmInput?.trim().toUpperCase() ?? '';
      if (confirm == 'Y') {
        print('이용해 주셔서 감사합니다 ~ 안녕히 가세요 ! ');
        break;
      } else if (confirm == 'N') {
        print('프로그램을 계속합니다.');
      } else {
        print('유효하지 않은 입력입니다. 계속합니다.');
      }
    } else {
      print('잘못된 입력입니다. 메뉴를 다시 선택해 주세요.');
    }
  }
}