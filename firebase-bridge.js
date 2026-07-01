const settings = window.CREI_FIREBASE_CONFIG || {};
const ready = !!(settings.enabled && settings.firebaseConfig?.apiKey && settings.firebaseConfig?.projectId && settings.firebaseConfig?.appId);

async function createFirebaseBridge() {
  if (!ready) {
    return { enabled: false, status: 'not-configured', async load() { return null; }, async save() { return false; } };
  }

  const [appModule, authModule, firestoreModule, analyticsModule] = await Promise.all([
    import('https://www.gstatic.com/firebasejs/12.15.0/firebase-app.js'),
    import('https://www.gstatic.com/firebasejs/12.15.0/firebase-auth.js'),
    import('https://www.gstatic.com/firebasejs/12.15.0/firebase-firestore.js'),
    import('https://www.gstatic.com/firebasejs/12.15.0/firebase-analytics.js').catch(() => null)
  ]);

  const app = appModule.initializeApp(settings.firebaseConfig);

  if (settings.firebaseConfig.measurementId && analyticsModule?.isSupported && await analyticsModule.isSupported()) {
    analyticsModule.getAnalytics(app);
  }

  try {
    await authModule.signInAnonymously(authModule.getAuth(app));
  } catch (error) {
    console.warn('Autenticacao anonima indisponivel. Verifique o Auth anonimo no Firebase.', error);
  }

  const db = firestoreModule.getFirestore(app);
  const collection = settings.collection || 'appSnapshots';
  const documentId = settings.documentId || 'default';
  const snapshotRef = firestoreModule.doc(db, collection, documentId);

  return {
    enabled: true,
    status: 'firestore',
    async load() {
      const snapshot = await firestoreModule.getDoc(snapshotRef);
      return snapshot.exists() ? snapshot.data()?.payload || null : null;
    },
    async save(payload) {
      await firestoreModule.setDoc(snapshotRef, {
        payload,
        updatedAt: firestoreModule.serverTimestamp()
      }, { merge: true });
      return true;
    }
  };
}

window.CREI_FIREBASE_READY = createFirebaseBridge()
  .then(bridge => {
    window.CREI_FIREBASE = bridge;
    return bridge;
  })
  .catch(error => {
    console.error('Firebase indisponivel.', error);
    window.CREI_FIREBASE = { enabled: false, status: 'error', async load() { return null; }, async save() { return false; } };
    return window.CREI_FIREBASE;
  });
