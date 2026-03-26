// extensions/payment-discount/src/run.js

export function run(input) {
  // Sepet alt toplamı ve aktif ödeme yöntemi belirleniyor
  // 'payment_method' verisi cart attribute (sepet niteliği) olarak beklenmektedir.
  const paymentMethod = input.cart.attribute?.value || "";
  
  // Metafield üzerinden belirlenen indirim oranını çekiyoruz (Eğer boş ise varsayılan %10)
  const discountPercentage = parseFloat(input.discountNode.metafield?.value || "10");

  // Eğer ödeme yönteminde "Havale" veya "Bank Transfer" anahtar kelimeleri geçiyorsa indirim uygula
  if (
    paymentMethod.toLowerCase().includes("havale") || 
    paymentMethod.toLowerCase().includes("bank transfer") ||
    paymentMethod.toLowerCase().includes("eft")
  ) {
    return {
      discounts: [
        {
          value: {
            percentage: {
              value: discountPercentage
            }
          },
          targets: [
            {
              orderSubtotal: {
                excludedVariantIds: []
              }
            }
          ],
          message: `Havale/EFT İndirimi (%${discountPercentage})`
        }
      ],
      discountApplicationStrategy: "FIRST"
    };
  }

  // Koşul sağlanmıyorsa indirim uygulama
  return {
    discounts: [],
    discountApplicationStrategy: "FIRST"
  };
}
