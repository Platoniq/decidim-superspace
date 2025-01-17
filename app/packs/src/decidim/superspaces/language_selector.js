class LanguageSelector {
  constructor(superspaceId, superspaceLocale, currentLocale) {
    this.superspaceId = superspaceId;
    this.superspaceLocale = superspaceLocale;
    this.currentLocale = currentLocale;
        
            
  }

  createCookie(value) {
    let name = `superspace_${this.superspaceId.toString()}_language_preference`
    let days = 30;
    let expires = "";
    let date = new Date();
    date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
    expires = `; expires=${date.toUTCString()}`;
    document.cookie = `${name}=${value}${expires}`;
    document.getElementById("dc-dialog-locale-wrapper").style.display = "none";
  }

  readCookie() {
    let name = `superspace_${this.superspaceId.toString()}_language_preference`
    let nameEQ = `${name}=`;
    let ca = document.cookie.split(";");
    for (let index = 0; index < ca.length; index += 1) {
      let cookie = ca[index];
      while (cookie.charAt(0) === " ") {
        cookie = cookie.substring(1, cookie.length);
      }
      if (cookie.indexOf(nameEQ) === 0) {
        return cookie.substring(nameEQ.length, cookie.length);
      }
    }
    return null;
  }

  showCookiePrompt() {
    return (this.readCookie() === null && (this.currentLocale !== this.superspaceLocale))
  }

  sameLocales() {
    return (this.currentLocale.toString() === this.superspaceLocale.toString())
  }

  changeLocale() {
    if (!this.sameLocales()) {
      const url = `${this.superspaceId}?locale=${this.superspaceLocale}`;
      window.location.href = url;
    }
  }
}

const wrapper = document.getElementById("dc-dialog-locale-wrapper");
let superspaceId = wrapper.dataset.superspaceId;
let superspaceLocale = wrapper.dataset.superspaceLocale;
let currentLocale = wrapper.dataset.currentLocale;

const language = new LanguageSelector(superspaceId, superspaceLocale, currentLocale);


document.addEventListener("DOMContentLoaded", () => {
  if (!language.showCookiePrompt()) {
    document.getElementById("dc-dialog-locale-wrapper").style.display = "none";
    if (language.readCookie().trim() === "change") {
      language.changeLocale();
    };
  };
});

document.getElementById("dc-dialog-cookie-reject").addEventListener("click", function() {
  language.createCookie("keep");
  document.getElementById("dc-dialog-locale-wrapper").style.display = "none";
});

document.getElementById("dc-dialog-cookie-accept").addEventListener("click", function() {
  language.createCookie("change");
  document.getElementById("dc-dialog-locale-wrapper").style.display = "none";
  location.reload();
});

document.getElementById("dc-dialog-cookie-reject").addEventListener("click", function() {
  language.createCookie("keep");
  document.getElementById("dc-dialog-locale-wrapper").style.display = "none";
});   
