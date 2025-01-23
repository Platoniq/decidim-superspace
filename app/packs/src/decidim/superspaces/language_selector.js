class LanguageSelector {
  constructor(superspaceId, superspaceLocale, currentLocale) {
    this.superspaceId = superspaceId;
    this.superspaceLocale = superspaceLocale;
    this.currentLocale = currentLocale;
  }

  createCookie(value) {
    const name = `superspace_${this.superspaceId.toString()}_language_preference`
    const days = 30;
    const date = new Date();
    date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
    const expires = `; expires=${date.toUTCString()}`;
    document.cookie = `${name}=${value}${expires}`;
    document.getElementById("dc-dialog-locale-wrapper").style.display = "none";
  }

  readCookie() {
    const name = `superspace_${this.superspaceId.toString()}_language_preference`
    const nameEQ = `${name}=`;
    const ca = document.cookie.split(";");
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
    return (this.readCookie() === null && (this.currentLocale !== this.superspaceLocale));
  }

  sameLocales() {
    return (this.currentLocale.toString() === this.superspaceLocale.toString());
  }

  changeLocale() {
    if (!this.sameLocales()) {
      window.location.href = `${this.superspaceId}?locale=${this.superspaceLocale}`;
    }
  }
}

const wrapper = document.getElementById("dc-dialog-locale-wrapper");
const superspaceId = wrapper.dataset.superspaceId;
const superspaceLocale = wrapper.dataset.superspaceLocale;
const currentLocale = wrapper.dataset.currentLocale;

const language = new LanguageSelector(superspaceId, superspaceLocale, currentLocale);

document.addEventListener("DOMContentLoaded", () => {
  if (!language.showCookiePrompt()) {
    document.getElementById("dc-dialog-locale-wrapper").style.display = "none";
    if (language.readCookie().trim() === "change") {
      language.changeLocale();
    }
  }
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
