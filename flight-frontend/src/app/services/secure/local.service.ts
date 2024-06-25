import { Injectable } from '@angular/core';
import { StorageService } from './storage.service';

@Injectable({
  providedIn: 'root'
})
export class LocalService {

  constructor(private storageService: StorageService) { }

  public setJsonValue(key: string, value: any): void {
    this.storageService.secureStorage.setItem(key, value);
  }

  getJsonValue(key: string): any {
    return this.storageService.secureStorage.getItem(key);
  }

  clearToken(): void {
    return this.storageService.secureStorage.clear();
  }
}
