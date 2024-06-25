// This file can be replaced during build by using the `fileReplacements` array.
// `ng build` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.

export const environment = {
  production: false,
  auth: {
    domain: 'bpichincha.us.auth0.com',
    clientId: 'yYCsjqU7NHP1fq5TbuwEMySzDTDzigtm',
    redirectUri: window.location.origin,
    audience: 'https://flight-backend.alchimia-innovation.com',
  },
  uriRest: 'http://localhost:5005',
  uriStripe: 'https://stripe.com/',
  uriPayPal: 'https://www.paypal.com/',
  SECRET_KEY: 'G1hxJ7l@%QUW5&@v1mh%ROY1n#4Tds05qnaO7i9zIgmEP%6a0PFnl4$h$K',
};

/*
 * For easier debugging in development mode, you can import the following file
 * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
 *
 * This import should be commented out in production mode because it will have a negative impact
 * on performance if an error is thrown.
 */
// import 'zone.js/plugins/zone-error';  // Included with Angular CLI.
