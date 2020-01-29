import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { FastCodeCoreTranslateUiService } from 'projects/fast-code-core/src/public_api';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})

export class AppComponent {
  title = 'fcclient';

  constructor(
    private translate: TranslateService,
    private fastCodeCoreTranslateUiService: FastCodeCoreTranslateUiService,
  ) {
    let languages = ["en", "fr"];
    let defaultLang = languages[0];
    translate.addLangs(languages);
    translate.setDefaultLang(defaultLang);

    let browserLang = translate.getBrowserLang();
    let lang = "";

    let selectedLanguage = localStorage.getItem('selectedLanguage');
    if (selectedLanguage && languages.includes(selectedLanguage)) {
      lang = selectedLanguage;
    }
    else {
      lang = languages.includes(browserLang) ? browserLang : defaultLang;
      localStorage.setItem('selectedLanguage', lang);
    }

    translate.use(lang).subscribe(() => {
      defaultLang = this.translate.defaultLang;
      if (defaultLang != lang) {
        this.initializeLibrariesTranslations(defaultLang);
      }
      this.initializeLibrariesTranslations(lang);
    });

  }

  initializeLibrariesTranslations(lang: string) {
    this.fastCodeCoreTranslateUiService.init(lang);
  }

}
