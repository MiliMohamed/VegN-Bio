import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/room_service.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({Key? key}) : super(key: key);

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final RoomService _roomService = RoomService();
  List<Room> _rooms = [];
  bool _loading = true;
  String? _error;
  int? _selectedRestaurantId;
  int? _minCapacity;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    if (_selectedRestaurantId == null) return;

    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final rooms = await _roomService.getAvailableRooms(
        _selectedRestaurantId!,
        minCapacity: _minCapacity,
      );
      
      setState(() {
        _rooms = rooms;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _showReservationDialog(Room room) {
    showDialog(
      context: context,
      builder: (context) => ReservationDialog(room: room),
    ).then((_) => _loadRooms()); // Recharger après réservation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservation de Salles'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filtres
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: _selectedRestaurantId,
                  decoration: const InputDecoration(
                    labelText: 'Restaurant',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('VEG\'N BIO BASTILLE')),
                    DropdownMenuItem(value: 2, child: Text('VEG\'N BIO REPUBLIQUE')),
                    DropdownMenuItem(value: 3, child: Text('VEG\'N BIO NATION')),
                    DropdownMenuItem(value: 4, child: Text('VEG\'N BIO PLACE D\'ITALIE')),
                    DropdownMenuItem(value: 5, child: Text('VEG\'N BIO BEAUBOURG')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRestaurantId = value;
                    });
                    _loadRooms();
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _minCapacity,
                  decoration: const InputDecoration(
                    labelText: 'Capacité minimum',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Toutes les capacités')),
                    DropdownMenuItem(value: 2, child: Text('2+ personnes')),
                    DropdownMenuItem(value: 4, child: Text('4+ personnes')),
                    DropdownMenuItem(value: 6, child: Text('6+ personnes')),
                    DropdownMenuItem(value: 8, child: Text('8+ personnes')),
                    DropdownMenuItem(value: 10, child: Text('10+ personnes')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _minCapacity = value;
                    });
                    _loadRooms();
                  },
                ),
              ],
            ),
          ),
          
          // Contenu
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Erreur',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadRooms,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : _rooms.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.meeting_room_outlined, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucune salle disponible',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Modifiez vos critères de recherche',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _rooms.length,
                            itemBuilder: (context, index) {
                              final room = _rooms[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  room.name,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  room.restaurantName,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                if (room.description.isNotEmpty)
                                                  Text(
                                                    room.description,
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: room.isAvailable ? Colors.green[100] : Colors.red[100],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              room.isAvailable ? 'Disponible' : 'Indisponible',
                                              style: TextStyle(
                                                color: room.isAvailable ? Colors.green[700] : Colors.red[700],
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      
                                      // Équipements
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: [
                                          _buildEquipmentChip('Wi-Fi', room.hasWifi),
                                          _buildEquipmentChip('Imprimante', room.hasPrinter),
                                          _buildEquipmentChip('Projecteur', room.hasProjector),
                                          _buildEquipmentChip('Tableau', room.hasWhiteboard),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 12),
                                      
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                const Icon(Icons.people, size: 16, color: Colors.grey),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${room.capacity} personnes',
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (room.hourlyRate > 0)
                                            Text(
                                              '${room.hourlyRate.toStringAsFixed(2)} €/h',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 16),
                                      
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: room.isAvailable
                                              ? () => _showReservationDialog(room)
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            room.isAvailable ? 'Réserver' : 'Indisponible',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentChip(String label, bool available) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: available ? Colors.blue[50] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: available ? Colors.blue[700] : Colors.grey[500],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ReservationDialog extends StatefulWidget {
  final Room room;

  const ReservationDialog({Key? key, required this.room}) : super(key: key);

  @override
  State<ReservationDialog> createState() => _ReservationDialogState();
}

class _ReservationDialogState extends State<ReservationDialog> {
  final RoomService _roomService = RoomService();
  final _formKey = GlobalKey<FormState>();
  
  DateTime? _startTime;
  DateTime? _endTime;
  final _purposeController = TextEditingController();
  int _attendeesCount = 1;
  final _specialRequirementsController = TextEditingController();
  final _notesController = TextEditingController();
  
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Définir des valeurs par défaut
    final now = DateTime.now();
    _startTime = DateTime(now.year, now.month, now.day + 1, 9, 0);
    _endTime = DateTime(now.year, now.month, now.day + 1, 10, 0);
  }

  @override
  void dispose() {
    _purposeController.dispose();
    _specialRequirementsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _createReservation() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startTime == null || _endTime == null) return;

    setState(() {
      _loading = true;
    });

    try {
      final request = CreateReservationRequest(
        roomId: widget.room.id,
        startTime: _startTime!,
        endTime: _endTime!,
        purpose: _purposeController.text,
        attendeesCount: _attendeesCount,
        specialRequirements: _specialRequirementsController.text.isEmpty 
            ? null 
            : _specialRequirementsController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      await _roomService.createReservation(request);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Réservation créée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Réserver ${widget.room.name}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Informations de la salle
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Capacité: ${widget.room.capacity} personnes',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (widget.room.hourlyRate > 0)
                      Text('Tarif: ${widget.room.hourlyRate.toStringAsFixed(2)} €/h'),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Date et heure de début
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Heure de début'),
                subtitle: Text(_startTime?.toString().substring(0, 16) ?? 'Non sélectionné'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startTime ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_startTime ?? DateTime.now()),
                    );
                    if (time != null) {
                      setState(() {
                        _startTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      });
                    }
                  }
                },
              ),
              
              // Date et heure de fin
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Heure de fin'),
                subtitle: Text(_endTime?.toString().substring(0, 16) ?? 'Non sélectionné'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _endTime ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_endTime ?? DateTime.now()),
                    );
                    if (time != null) {
                      setState(() {
                        _endTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      });
                    }
                  }
                },
              ),
              
              // But de la réservation
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'But de la réservation *',
                  hintText: 'Ex: Réunion équipe, Formation...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez indiquer le but de la réservation';
                  }
                  return null;
                },
              ),
              
              // Nombre de participants
              TextFormField(
                initialValue: _attendeesCount.toString(),
                decoration: const InputDecoration(
                  labelText: 'Nombre de participants',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _attendeesCount = int.tryParse(value) ?? 1;
                },
                validator: (value) {
                  final count = int.tryParse(value ?? '');
                  if (count == null || count < 1) {
                    return 'Nombre invalide';
                  }
                  if (count > widget.room.capacity) {
                    return 'Dépasse la capacité de la salle (${widget.room.capacity})';
                  }
                  return null;
                },
              ),
              
              // Exigences spéciales
              TextFormField(
                controller: _specialRequirementsController,
                decoration: const InputDecoration(
                  labelText: 'Exigences spéciales',
                  hintText: 'Ex: Équipement audiovisuel, restauration...',
                ),
                maxLines: 2,
              ),
              
              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes supplémentaires',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _createReservation,
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Réserver'),
        ),
      ],
    );
  }
}
