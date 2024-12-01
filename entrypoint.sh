#!/bin/sh

# Run the migration
echo "Running migration..."
/app/bin/migrate

# Check if the migration command was successful
if [ $? -ne 0 ]; then
	echo "Migration failed, exiting."
	exit 1
fi

# If migration was successful, run the server
echo "Starting server..."
exec /app/bin/server
