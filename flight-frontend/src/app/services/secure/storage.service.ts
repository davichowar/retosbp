import { Injectable } from '@angular/core';
import * as CryptoJS from 'crypto-js';
import { environment } from 'src/environments/environment';
// @ts-ignore
import SecureStorage from 'secure-web-storage';

const SECRET_KEY = environment.SECRET_KEY;

@Injectable({
  providedIn: 'root'
})
export class StorageService {

  constructor() { }

  public secureStorage = new SecureStorage(localStorage, {
    hash: function hash(key: any): any {
      key = CryptoJS.HmacSHA256(key, SECRET_KEY);

      return key.toString();
    },
    encrypt: function encrypt(data: any): any {
      data = CryptoJS.AES.encrypt(data, SECRET_KEY);

      data = data.toString();

      return data;
    },
    decrypt: function decrypt(data: any): any {
      data = CryptoJS.AES.decrypt(data, SECRET_KEY);

      data = data.toString(CryptoJS.enc.Utf8);

      return data;
    }
  });
}
