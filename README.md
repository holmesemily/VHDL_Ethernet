# VHDL_Ethernet


On a construit notre module Ethernet autour de 3 composants différents:

Signaux communs à tous les modules : 
      RESETN -> Force la réinitialisation du module ethernet
      CLK10I -> Clock

 -- Transmitter --
Signals:

Input 
      TABORTP -> Qui demande l'arrêt de la transmission
      TAVAILP -> Les données sont prêtes à êtres envoyées
      TFINISHP -> La transmission doit être terminée
      TDATAI -> Informations à transmettre
      TLASTP -> Dernier Bit de data vient d'être envoyé
      TSOCOLP, TSMCOLP, TSECOLP -> Information sur l'état des collisions
      
Output 
      TDATAO -> Informations envoyées
      TDONEP -> Transmission terminée
      TREADDP -> Octet disponible vient d'être lu
      TRNSMTP -> Transmission en cours
      TSTARTP -> Commencement de la transmission
      TSUCCESS, TFAIL -> Informe du succès ou de l'échec de la transmission du message
      
Fonction du Transmitter:
Transmet un message, sauf si RESET (réinitialisation) ou TABORTP, TSOCOLP, TSMCOLP auquel cas on abandonne puis on réessaie
Si TSECOLP on abandonne totalement la tentative de transmission
      
 -- Receiver --
Signals:
 
Input 
      RENABP -> Module en état de recevoir
      RDATAI -> vecteur contenant les informations reçues
      
Output
      RBYTEP -> 
      RCLEANP -> Cas d'erreur
      RCVNGP -> Réception en cours
      RDONEP -> Bit bien reçu
      RSMATIP -> Adresse correcte
      RSTARTP -> Informe que le message est reçu
      RDATAO -> vecteur contenant les informations envoyées à la couche supérieure
      
Fonction du Receiver:
Réception d'un message sur RDATAI qu'on transmet via RDATAO à la couche supérieure
 
 -- Collision --
Signals:
 
Input
      TRNSMTP -> Le transmitter est en cours de transmission
      RCVNGP -> Le receiver est en cours de réception
      TABORTP -> La transmission est actuellement en arrêt
      TSUCCESS -> La transmission a été correctement effectuée
      TFAIL -> La transmission a été échouée
      
Output
      TSOCOLP -> Une collision détéctée
      TSMCOLP -> Multiples collisions détéctées
      TSECOLP -> Trop de collisions, annulation de l'envoi
      
Fonction de Collision:
Vérifie si une transmission a lieu en même temps qu'une réception, dans ce cas il envoie au composant Transmitter l'information de retransmettre ou pas
selon le nombre de tentatives déjà ratées. Si TSUCCESS on réinitialise le nombre de collisions.
 
 
-- Rajouter plus d'infos signaux intermédiaires? Signaux d'entrée sortie du module complet? Enlever des infos?
 
 
