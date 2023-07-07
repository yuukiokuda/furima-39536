const pay = () => {
  const publicKey = gon.public_key
  const payjp = Payjp(publicKey) // PAY.JPテスト公開鍵
  
  const elements = payjp.elements();
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');
    // 入力フォームの作成のために定義づけ、フォームのtypeを指定

  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');
    // viewのためにフォームの置きかえ

  const form = document.getElementById('charge-form')
  form.addEventListener("submit", (e) => {
    // javaで処理されるためのコード charge-form としてトークンを生成する準備

    payjp.createToken(numberElement).then(function (response) {
      if (response.error) {
      } else {
        const token = response.id;
        const renderDom = document.getElementById("charge-form");
        const tokenObj = `<input value=${token} name='token' type="hidden">`;
        renderDom.insertAdjacentHTML("beforeend", tokenObj);
        console.log(token)
      }
    // トークンを作成、type="hidden"で生成されたトークンを見えないようにする。

      numberElement.clear();
      expiryElement.clear();
      cvcElement.clear();
      // トークンが生成されたので、入力されたクレジットカード情報を削除する

      document.getElementById("charge-form").submit();
      // トークが入ったcharge-formをサーバーサイドに送信

    });
    e.preventDefault();
    // デフォルト（Rails）のフォーム送信処理はキャンセルするように指示
  });
};

window.addEventListener("turbo:load", pay);